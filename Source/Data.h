/*
  ==============================================================================

    Data.h
    Created: 3 Jun 2014 11:46:57pm
    Author:  Adam Elemental

  ==============================================================================
*/

#ifndef DATA_H_INCLUDED
#define DATA_H_INCLUDED

#include "../JuceLibraryCode/JuceHeader.h"

namespace Ids
{
#define DECLARE_ID(name)      const Identifier name (#name)

    DECLARE_ID (file);

    const Identifier title ("title");
    const Identifier message  ("message");

    const Identifier dataType ("Data");
    const Identifier messageType ("Message");

    #undef DECLARE_ID
};

class Data
{
public:
    Data()
    {
    }

    // build data from JSON string
    Data(String json)
    {
        updateFromJSON (json);
    }

    Result updateFromJSON (String json)
    {
        DBG ("updateFromJSON");

        var dataVar;
        Result result = JSON::parse (json, dataVar);
        DBG ("Got data: " << dataVar.toString());

        if (result.wasOk())
        {

            dataValueTree = ValueTree (Ids::dataType);
            Array<var>* dataArray = dataVar.getArray();

            for (auto dataItem : *dataArray)
            {

                ValueTree messageValueTree(Ids::messageType);
                messageValueTree.setProperty(Ids::title, dataItem.getProperty(Ids::title, "Untitled"), nullptr);
                messageValueTree.setProperty(Ids::message, dataItem.getProperty(Ids::message, "Empty message"), nullptr);

                DBG ("adding message: " << messageValueTree.toXmlString());
                dataValueTree.addChild (messageValueTree, -1, nullptr);
            }
        }
        else
        {
            DBG ("!!!!!!! error parsing JSON");
            DBG (result.getErrorMessage());
        }
        return result;
    }

    String toJson() noexcept
    {
        /** data convert to JSON **/
        Array<var> varItems;

        for (int i = 0; i < dataValueTree.getNumChildren(); ++i)
        {
            var title = dataValueTree.getChild(i).getProperty(Ids::title);
            var message = dataValueTree.getChild(i).getProperty(Ids::message);
            var item;
            item.append (title);
            item.append (message);
            varItems.add (item);
        }

        return JSON::toString (var (varItems));
    }

    ValueTree & getValueTree()
    {
        return dataValueTree;
    }



private:
    String title;
    ValueTree dataValueTree;
    var data;
};


#endif  // DATA_H_INCLUDED
