//
// $Id$
//
// Vilya library - tools for developing networked games
// Copyright (C) 2002-2010 Three Rings Design, Inc., All Rights Reserved
// http://code.google.com/p/vilya/
//
// This library is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

package com.threerings.whirled.data {

import com.threerings.util.ClassUtil;
import com.threerings.util.Cloneable;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;
import com.threerings.io.SimpleStreamableObject;
import com.threerings.io.TypedArray;

/**
 * The scene model is the bare bones representation of the data for a
 * scene in the Whirled system. From the scene model, one would create an
 * instance of {@link Scene}.
 *
 * <p> The scene model is what is loaded from the scene repositories and
 * what is transmitted over the wire when communicating scenes from the
 * server to the client.
 */
public class SceneModel extends SimpleStreamableObject
    implements Cloneable
{
    /** This scene's unique identifier. */
    public var sceneId :int;

    /** The human readable name of this scene. */
    public var name :String;

    /** The version number of this scene. Versions are incremented
     * whenever modifications are made to a scene so that clients can
     * determine whether or not they have the latest version of a
     * scene. */
    public var version :int;

    /** Auxiliary scene model information. */
    public var auxModels :TypedArray = TypedArray.create(AuxModel);

    /**
     * Creates and returns a blank scene model.
     */
    public static function blankSceneModel () :SceneModel
    {
        var model :SceneModel = new SceneModel();
        populateBlankSceneModel(model);
        return model;
    }

    public function SceneModel ()
    {
        // nothing needed
    }

    /**
     * Adds the specified auxiliary model to this scene model.
     */
    public function addAuxModel (auxModel :AuxModel) :void
    {
        auxModels.push(auxModel);
    }

    // documentation inherited from interface Cloneable
    public function clone () :Object
    {
        var clazz :Class = ClassUtil.getClass(this);
        var model :SceneModel = new clazz();

        model.sceneId = sceneId;
        model.name = name;
        model.version = version;

        for each (var aux :AuxModel in auxModels) {
            model.addAuxModel(aux.clone() as AuxModel);
        }
        return model;
    }

    // documentation inherited from interface Streamable
    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        sceneId = ins.readInt();
        name = (ins.readField(String) as String);
        version = ins.readInt();
        auxModels = TypedArray(ins.readObject());
    }

    // documentation inherited from interface Streamable
    override public function writeObject (out :ObjectOutputStream) :void
    {
        super.writeObject(out);
        out.writeInt(sceneId);
        out.writeField(name);
        out.writeInt(version);
        out.writeObject(auxModels);
    }

    /**
     * Populates a blank scene model with blank values.
     */
    protected static function populateBlankSceneModel (model :SceneModel) :void
    {
        model.sceneId = -1;
        model.name = "<blank>";
        model.version = 0;
    }
}
}
