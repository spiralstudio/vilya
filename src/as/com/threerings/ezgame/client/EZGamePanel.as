package com.threerings.ezgame.client {

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

import flash.events.Event;

import flash.utils.Dictionary;

import mx.containers.Canvas;
import mx.containers.VBox;

import mx.core.Container;
import mx.core.IChildList;

import mx.utils.DisplayUtil;

import com.threerings.crowd.client.PlaceView;
import com.threerings.crowd.data.PlaceObject;
import com.threerings.crowd.util.CrowdContext;

import com.threerings.ezgame.data.EZGameConfig;
import com.threerings.ezgame.data.EZGameObject;

import com.threerings.ezgame.Game;

public class EZGamePanel extends VBox
    implements PlaceView
{
    public function EZGamePanel (ctx :CrowdContext, ctrl :EZGameController)
    {
        _ctx = ctx;
        _ctrl = ctrl;

        // add a listener so that we hear about all new children
        addEventListener(Event.ADDED, childAdded);

        // TODO: figure out how we're going to add the client game
        var cfg :EZGameConfig = (ctrl.getPlaceConfig() as EZGameConfig);
        //_gameView = new MsoySprite(cfg.game);
        //addChild(_gameView);

        // TODO: move chat component into narya?
        //addChild(new ChatTextArea(ctx));
    }

    // from PlaceView
    public function willEnterPlace (plobj :PlaceObject) :void
    {
        // don't start notifying anything of the game until we've
        // notified the game manager that we're in the game
        // (done in GameController, and it uses callLater, so we do it twice!)
        _ctx.getClient().callLater(function () :void {
            _ctx.getClient().callLater(function () :void {
                _ezObj = (plobj as EZGameObject);

                notifyOfGame(this);
            });
        });
    }

    // from PlaceView
    public function didLeavePlace (plobj :PlaceObject) :void
    {
        _ezObj = null;
    }

    /**
     * Handle ADDED events.
     */
    protected function childAdded (event :Event) :void
    {
        if (_ezObj != null) {
            notifyOfGame(event.target as DisplayObject);
        }
    }

    /**
     * Find any children of the specified object that implement
     * com.metasoy.game.Game and provide them with the GameObject.
     */
    protected function notifyOfGame (root :DisplayObject) :void
    {
        DisplayUtil.walkDisplayObjects(root,
            function (disp :DisplayObject) :void
            {
                if (disp is Game) {
                    // only notify the Game if we haven't seen it before
                    if (null == _seenGames[disp]) {
                        (disp as Game).setGameObject(_ctrl.gameObjImpl);
                        _seenGames[disp] = true;
                    }
                }
            });
    }

    protected var _ctx :CrowdContext;
    protected var _ctrl :EZGameController;

    /** A weak-key hash of the Game interfaces we've already seen. */
    protected var _seenGames :Dictionary = new Dictionary(true);

    protected var _ezObj :EZGameObject;
}
}
