local ffi = require("ffi")
local class = require('pl.class')
local gme = ffi.load("gme")

ffi.cdef([[
    typedef const char* gme_err_t;
    typedef struct Music_Emu Music_Emu;
    gme_err_t gme_open_file( const char path [], Music_Emu** out, int sample_rate );
]])

local musicemuptr = ffi.new("Music_Emu*[1]")
local mario = gme.gme_open_file("mario.nsf", musicemuptr, 48000)
local musicemu = musicemuptr[0]

print("lol", musicemu)

class.GmePlayer()

return GmePlayer