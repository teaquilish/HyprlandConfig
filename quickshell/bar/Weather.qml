pragma Singleton

import QtQuick
import Quickshell

// Current weather, one reading shared by every screen. Location is
// Settings.weatherCity, or the IP location when that is empty.
Singleton {
    id: root

    property bool ready:       false
    property real temperature: 0
    property int  code:        0
    property bool isDay:       true
    readonly property string glyph: glyphFor(code, isDay)

    property bool hasLocation:    false
    property real latitude:       0
    property real longitude:      0
    property bool quickRetryUsed: false
    property bool busy:           false
    // Bumped on every city change, answers to an older city are dropped
    property int  generation:     0
    // { xhr, done } while a request runs, null when idle
    property var  request:        null

    // WMO weather code to Nerd Font Weather Icons glyph (nf-weather-*)
    function glyphFor(code, day) {
        if (code <= 1)
            return day ? "\ue30d" : "\ue32b";  // day_sunny, night_clear
        if (code === 2)
            return day ? "\ue302" : "\ue379";  // day_cloudy, night_alt_partly_cloudy
        if (code === 3)
            return "\ue312";                   // cloudy
        if (code === 45 || code === 48)
            return "\ue313";                   // fog
        if (code >= 51 && code <= 55)
            return "\ue31b";                   // sprinkle (drizzle)
        if (code === 56 || code === 57 || code === 66 || code === 67)
            return "\ue3ad";                   // sleet (freezing drizzle/rain)
        if (code >= 61 && code <= 65)
            return "\ue318";                   // rain
        if (code >= 80 && code <= 82)
            return "\ue319";                   // showers
        if ((code >= 71 && code <= 77) || code === 85 || code === 86)
            return "\ue31a";                   // snow
        if (code >= 95)
            return "\ue31d";                   // thunderstorm
        return "\ue33d";                       // cloud, unknown code
    }

    function refresh() {
        if (busy)
            return;
        quickRetry.stop();
        if (hasLocation)
            fetchWeather();
        else
            locate();
    }

    function locate() {
        var gen  = generation;
        var city = Settings.weatherCity.trim();
        if (city !== "") {
            var url = "https://geocoding-api.open-meteo.com/v1/search?name="
                + encodeURIComponent(city) + "&count=1";
            get(url, function (data) {
                if (gen !== generation)
                    return;
                var place = data && data.results ? data.results[0] : null;
                if (!place || typeof place.latitude !== "number" || typeof place.longitude !== "number")
                    return retryLater();
                onLocated(place.latitude, place.longitude);
            });
        } else {
            get("https://ipwho.is/", function (data) {
                if (gen !== generation)
                    return;
                if (!data || data.success !== true
                        || typeof data.latitude !== "number" || typeof data.longitude !== "number")
                    return retryLater();
                onLocated(data.latitude, data.longitude);
            });
        }
    }

    // Two decimals is about 1 km, enough for weather
    function onLocated(lat, lon) {
        latitude    = Math.round(lat * 100) / 100;
        longitude   = Math.round(lon * 100) / 100;
        hasLocation = true;
        fetchWeather();
    }

    function fetchWeather() {
        var gen = generation;
        var url = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude
                + "&longitude=" + longitude
                + "&current=temperature_2m,weather_code,is_day&timezone=auto";
        get(url, function (data) {
            if (gen !== generation)
                return;
            var c = data && data.current ? data.current : null;
            if (!c || typeof c.temperature_2m !== "number"
                    || typeof c.weather_code !== "number" || typeof c.is_day !== "number")
                return retryLater();
            temperature = c.temperature_2m;
            code        = c.weather_code;
            isDay       = c.is_day === 1;
            ready       = true;
            quickRetry.stop();
        });
    }

    // One quick retry while there is no reading yet, the 15 min timer covers the rest
    function retryLater() {
        if (ready || quickRetryUsed)
            return;
        quickRetryUsed = true;
        quickRetry.restart();
    }

    // Calls done(parsed JSON) on HTTP 200, done(null) on any other failure.
    // At most one request runs at a time, busy stays true until it ends.
    function get(url, done) {
        busy = true;
        var xhr = new XMLHttpRequest();
        request = { xhr: xhr, done: done };
        requestTimer.restart();
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE || !request || request.xhr !== xhr)
                return;
            var data = null;
            if (xhr.status === 200) {
                try {
                    data = JSON.parse(xhr.responseText);
                } catch (e) {
                    data = null;
                }
            }
            var finished = request.done;
            request = null;
            requestTimer.stop();
            busy = false;
            finished(data);
        };
        xhr.open("GET", url);
        xhr.send();
    }

    function abortRequest() {
        if (!request)
            return;
        var xhr = request.xhr;
        request = null;
        requestTimer.stop();
        busy = false;
        xhr.abort();
    }

    Component.onCompleted: refresh()

    Timer {
        interval:    15 * 60 * 1000
        repeat:      true
        running:     true
        onTriggered: root.refresh()
    }

    Timer {
        id:          quickRetry
        interval:    60 * 1000
        onTriggered: root.refresh()
    }

    // Gives up on a request that hangs, counts as a failure
    Timer {
        id:       requestTimer
        interval: 15 * 1000
        onTriggered: {
            if (!root.request)
                return;
            var finished = root.request.done;
            root.abortRequest();
            finished(null);
        }
    }

    Connections {
        target: Settings

        function onWeatherCityChanged() {
            root.generation++;
            root.abortRequest();
            root.ready         = false;
            root.quickRetryUsed = false;
            quickRetry.stop();
            root.hasLocation   = false;
            root.latitude      = 0;
            root.longitude     = 0;
            root.refresh();
        }
    }
}
