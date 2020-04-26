local ffi = require("ffi")
local class = require('pl.class')
local gme = ffi.load("gme")

ffi.cdef([[
    typedef const char* gme_err_t;
    typedef struct Music_Emu Music_Emu;
    gme_err_t gme_open_file( const char path [], Music_Emu** out, int sample_rate );
    int gme_track_count( Music_Emu const* );
    gme_err_t gme_start_track( Music_Emu*, int index );
    gme_err_t gme_play( Music_Emu*, int count, short out [] );
    void gme_delete( Music_Emu* );
]])



class.GmePlayer()
function GmePlayer:_init(path)
    local musicemuptr = ffi.new("Music_Emu*[1]")
    local status = gme.gme_open_file(path, musicemuptr, 48000)
    self.emu = musicemuptr[0]
    self.currentTrack = 0
    self.isPaused = true
    self.trackCount = gme.gme_track_count(self.emu)
    assert(self.trackCount > 1, "No tracks in file")
    gme.gme_start_track(self.emu, 0)
end

function GmePlayer:setPaused(newPaused)
    self.isPaused = newPaused
end

function GmePlayer:nextTrack()
    self.currentTrack = self.currentTrack + 1
    if self.currentTrack == self.trackCount then
        self.currentTrack = 0
    end
    gme.gme_start_track(self.emu, self.currentTrack)
end

function GmePlayer:prevTrack()
    self.currentTrack = self.currentTrack - 1
    if self.currentTrack == -1 then
        self.currentTrack = self.trackCount-1
    end
    gme.gme_start_track(self.emu, self.currentTrack)
end

function GmePlayer:generateAudio(sampleCount)
    local interleaved = ffi.new("short[?]", sampleCount*2)
    local left = ffi.new("short[?]", sampleCount)
    local right = ffi.new("short[?]", sampleCount)
    if not self.isPaused then
        gme.gme_play(self.emu, sampleCount*2, interleaved);
    end
    for i = 0, sampleCount*2 - 1, 1 do
        local target = (i % 2 == 0) and left or right
        target[i/2] = interleaved[i]
    end
    return ffi.string(left, sampleCount*2), ffi.string(right, sampleCount*2)
end

return GmePlayer