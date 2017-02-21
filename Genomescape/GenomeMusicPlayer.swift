//
//  GenomeMusicPlayer.swift
//  Genomescape
//
//  Created by Darius Miliauskas on 2017-02-20.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import AudioToolbox

class GenomeMusicPlayer: NSObject {
    
    func play(melody: [(UInt8, Int)]) {
        // Creating the sequence
        var sequence:MusicSequence? = nil
        if(NewMusicSequence(&sequence)==0) {
        }
        
        // Creating a track
        var track:MusicTrack? = nil
        var musicTrack = MusicSequenceNewTrack(sequence!, &track)
        
        // Adding notes
        addNote(track: track, melody: melody)
        /*var time = MusicTimeStamp(1.0)
        for index:UInt8 in 60...72 {
            var note = MIDINoteMessage(channel: 0,
                                       note: index,
                                       velocity: 64,
                                       releaseVelocity: 0,
                                       duration: 2.0)
            //musicTrack =
                MusicTrackNewMIDINoteEvent(track!, time, &note)
            time += 2
        }*/
        
        // Creating a player
        var musicPlayer:MusicPlayer? = nil
        var player = NewMusicPlayer(&musicPlayer)
        
        player = MusicPlayerSetSequence(musicPlayer!, sequence)
        player = MusicPlayerStart(musicPlayer!)
        
        
        MusicSequenceDisposeTrack(sequence!, track!)
    }
    
    func addNote(track: MusicTrack?, melody: [(UInt8, Int)]) {
        // var musicTrack = MusicSequenceNewTrack(sequence!, &track)
        var time = MusicTimeStamp(1.0)
        for item in melody {
            var note = MIDINoteMessage(channel: 0,
                                       note: item.0,
                                       velocity: 64,
                                       releaseVelocity: 0,
                                       duration: Float32(item.1))
            MusicTrackNewMIDINoteEvent(track!, time, &note)
            time += Float64(item.1)
        }
    }
}
