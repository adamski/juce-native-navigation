/*
  ==============================================================================

    Scale.h
    Created: 3 Jun 2014 11:46:57pm
    Author:  Adam Elemental

  ==============================================================================
*/

#ifndef SCALE_H_INCLUDED
#define SCALE_H_INCLUDED

#include "RationalNum.h"
#include "RatioObject.h"
#include "Note.h"
#include "../JuceLibraryCode/JuceHeader.h"

#include "Identifiers.h"

#define MAX_MIDI_NOTE 127

class Scale
{
public:

    Scale(ReferenceCountedArray<RationalNum> ratios, float baseFrequency) : ratios(ratios),
    baseFrequency(baseFrequency)
    {
        log = Logger::getCurrentLogger();
        scaleType = Identifier("scale");
        noteTree = ValueTree (scaleType);
        startOctave = defaultStartOctave;

        /* Convert Ratios to ValueTree */
        scaleTree = ValueTree (scaleType);
        scaleTree.setProperty (Ids::scaleBaseFrequency, baseFrequency, nullptr);
        for (auto ratio : ratios)
        {
            ValueTree noteRatio (Ids::ratioType);
            //singleNote.setProperty (Ids::noteRatio, var( new RatioObject(ratio)), nullptr);
            noteRatio.setProperty (Ids::noteNumerator, ratio->getNumerator(), nullptr);
            noteRatio.setProperty (Ids::noteDenominator, ratio->getDenominator(), nullptr);
            noteRatio.setProperty (Ids::noteDecimal, ratio->getValue(), nullptr);
            noteRatio.setProperty (Ids::noteLabel, ratio->getRationalString(), nullptr);
            scaleTree.addChild (noteRatio, -1, nullptr);

        }
    }


    Scale(ReferenceCountedArray<RationalNum> ratios) : Scale(ratios, defaultBaseFrequency)
    {
    }

    Scale() : Scale(ReferenceCountedArray<RationalNum>(), defaultBaseFrequency)
    {
    }

    // build scale from JSON string
    Scale(String json)
    {
        
        updateFromJSON (json);

    }
    
    Result updateFromJSON (String json)
    {
        
        var scaleVar;
        Result result = JSON::parse (json, scaleVar);
        
        DBG ("updateFromJSON");
        
        if (result.wasOk())
        {
            title = scaleVar.getProperty ("title", "Untitled");
            baseFrequency = scaleVar.getProperty ("baseFrequency", defaultBaseFrequency);
            Array<var>* varRatios = scaleVar.getProperty ("ratios", Array<var>()).getArray();
            
            /* Convert Ratios to ValueTree */
            scaleTree = ValueTree (scaleType);
            scaleTree.setProperty (Ids::scaleBaseFrequency, baseFrequency, nullptr);
            for (auto ratioVar : *varRatios)
            {
                ValueTree noteRatio (Ids::ratioType);
                noteRatio.setProperty (Ids::noteNumerator, ratioVar.getProperty (Ids::noteNumerator, 0), nullptr);
                noteRatio.setProperty (Ids::noteDenominator, ratioVar.getProperty (Ids::noteDenominator, 0), nullptr);
                int num = ratioVar.getProperty (Ids::noteNumerator, 0);
                int den = ratioVar.getProperty (Ids::noteDenominator, 0);
                noteRatio.setProperty (Ids::noteDecimal, (float) num / den, nullptr);
                noteRatio.setProperty (Ids::noteLabel, ratioVar.getProperty (Ids::noteLabel, String(num) + String("/") + String(den)), nullptr);
                scaleTree.addChild (noteRatio, -1, nullptr);
            }

            calculateNotes();
            calculateFrequencies();
            
            DBG ("done calculate notes");
        }
        else
        {
            DBG (result.getErrorMessage());
        }
        return result;
    }

    String toJson() noexcept
    {

        /** scale convert to JSON **/
        Array<var> varRatios;
        for (auto ratio : ratios)
        {
            varRatios.add (var (new RatioObject(ratio)));
        }

        DynamicObject* scaleRoot = new DynamicObject();


        scaleRoot->setProperty ("name", var ("12 Tone JI"));
        scaleRoot->setProperty ("description", var ("some description"));
        scaleRoot->setProperty ("baseFrequency", var (baseFrequency));
        scaleRoot->setProperty ("ratios", var (varRatios));

        return JSON::toString(var (scaleRoot));
    }

    float getFrequency(int index)
    {
        return baseFrequency * scaleTree.getChild (index).getProperty (Ids::noteDecimal).operator float();
    }

    RationalNum::Ptr getRatio(int index)
    {
        return ratios[index]; //.getObject();
    }


    /// currently not used  - DELETE?
    void calculateFrequencies()
    {
        //if (base_frequency) this->base_frequency = base_frequency;

        for (int i=0; i<ratios.size(); i++)
        {
            std::cout << String(i)+":"+ratios[i]->getRationalString()+":"+String(getFrequency(i));
            frequencies.set (i, getFrequency(i)); // <- TODO this should go in ValueTree

        }
    }

    void calculatePlayableNotes() 
    {
        // add frequencies and MIDI note numbers to scale
        // so we can play them with the synth class
        for (int i = 0; i < scaleTree.getNumChildren(); i++)
        {
            ValueTree note = ValueTree(scaleTree.getChild(i));
            float decimal = scaleTree.getChild(i).getProperty (Ids::noteDecimal).operator float();
            float frequency = decimal * getBaseFrequency();
            note.setProperty( Ids::noteFrequency, frequency, nullptr);
            note.setProperty( Ids::midiNoteNumber, i, nullptr );  // This is where we could map to given MIDI notes. 
        }
    }


    void calculateNotes (int octaves = defaultNumOctaves)
    {
        noteTree.removeAllChildren(nullptr);
        noteTree.setProperty (Ids::scaleBaseFrequency, baseFrequency, nullptr);
        int midiNoteNumber = 0;

        if (noteTree.isValid() && scaleTree.isValid())
        {
            frequencies.clear();
            float mult = getOctaveMultiplier (startOctave); //0.25; // starting multiplier
            DBG ("Octave Mult: " + String (mult));
            for (int j = 0; j < octaves; j++)
            {
                int octave = j;
                for (int i=0; i < scaleTree.getNumChildren(); i++)
                {
                    ValueTree noteNode (Ids::noteType);
                    ValueTree scaleRatio (scaleTree.getChild(i));
                    noteNode = scaleRatio.createCopy();

                    float currentFrequency = getFrequency(i)*mult;
                    /*RatioObject* ratioObject = dynamic_cast<RatioObject*> (scaleTree.getChild(i).getProperty(Ids::noteRatio).getDynamicObject());*/
                    //DBG ("scaleTree: getChildAt (" + String(i) + ") "+scaleTree.getChild(i).getProperty(Ids::noteLabel).toString());
                    /*jassert (ratioObject != nullptr);*/

                    String label;
                    if (! noteNode.hasProperty (Ids::noteLabel))
                    {
                        label = scaleRatio.getProperty (Ids::noteNumerator).toString() + "/" +
                                scaleRatio.getProperty (Ids::noteDenominator).toString();
                        noteNode.setProperty (Ids::noteLabel, label, nullptr);
                    }

                    // we need this for efficient binarySearch ... or do we?
                    frequencies.add (currentFrequency);

                    //set frequency based on current root frequency
                    noteNode.setProperty (Ids::noteFrequency, currentFrequency, nullptr);

                    //add and increment midi note number 
                    if (midiNoteNumber < MAX_MIDI_NOTE) 
                    {
                        noteNode.setProperty (Ids::midiNoteNumber, midiNoteNumber, nullptr);
                        midiNoteNumber++;
                    }
                    //find nearest western notation for display (allow option for other styles e.g. indian etc).
                    //noteNode.setProperty (noteNotation, findNearestWesternNotation(currentFrequency), nullptr);

                    noteNode.setProperty (Ids::noteOctave, octave, nullptr);
                    noteNode.setProperty (Ids::octaveMultiplier, mult, nullptr);

                    // add to noteTree
                    noteTree.addChild (noteNode, -1, nullptr);

                }
                // get next multiplier
                mult *= 2;
            }

            log->writeToLog("Scale - getNumChildren:"+String(noteTree.getNumChildren()));
            log->writeToLog("noteTree:"+String(noteTree.toXmlString()));
            String freqStr;
            for (auto f : frequencies) { freqStr << String(f) << ", "; }
            DBG ("frequencies: " + freqStr);

        } else {
           log->writeToLog("invalid noteTree!!");
        }
    }

    Array<float> const & getFrequencies() const
    {
        return frequencies;
    }

    ValueTree & getNoteTree()
    {
        //log->writeToLog("getNoteTree:"+String(noteTree.getNumChildren()));
        return noteTree;
    }

    ValueTree & getScaleTree()
    {
        return scaleTree;
    }

    void addRatio(RationalNum ratio) 
    {
        ratios.add(&ratio);
    }

    ReferenceCountedArray<RationalNum> getRatios()
    {
        return ratios;
    }

    void setBaseFrequency (float newFrequency, bool recalculate = true)
    {
        if (baseFrequency != newFrequency)
        {
            baseFrequency = newFrequency;
            scaleTree.setProperty (Ids::scaleBaseFrequency, newFrequency, nullptr);
            if (recalculate)
            {
                calculateFrequencies();
                calculateNotes();
            }
        }

    }

    float getOctaveMultiplier (int octave)
    {
        DBG ("octave: "+String (octave));
        if (octave == 0) return 1;
        float mult = 1;

        if (octave < 0)
        {
            for (int i = octave; i <= 0; i++) mult /= 2;
        }
        else if (octave > 0)
        {
            for (int i = 0; i < octave; i++) mult *= 2;
        }
        return mult;

    }

    float getBaseFrequency()
    {
        return baseFrequency;
    }

private:
    static constexpr float defaultBaseFrequency = 440.0;
    static constexpr int defaultNumOctaves = 5;
    static constexpr int defaultStartOctave = -2;
    String title;
    ValueTree noteTree;
    ValueTree scaleTree;
    var scale;
    ReferenceCountedArray<RationalNum> ratios;  // one octave or single set
    Array<float> frequencies;
    float baseFrequency;
    Array<float> octaveMults;
    int startOctave;

    Identifier noteNotation; // for Western or other notation
    Identifier scaleType;

    Logger *log;

    String findNearestWesternNotation (float frequency)
    {
        return "n/i"; // not implemented yet..

        /// use aubio for this?

        /* thoughts: start at root note, find nearest western notation then work the rest out according to ratios..
         * could get complicated!!
         */
    }
};


#endif  // SCALE_H_INCLUDED
