-- NVIDIA: OpenGL and hardware video decoding
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME",         "nvidia")
hl.env("NVD_BACKEND",               "direct")

-- Cursor
hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("XCURSOR_SIZE",  "24")
