//
// $Id$
//
// Narya library - tools for developing networked games
// Copyright (C) 2002-2004 Three Rings Design, Inc., All Rights Reserved
// http://www.threerings.net/code/narya/
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

package com.threerings.parlor.card.data;

import com.threerings.util.ActionScript;
import com.threerings.util.StreamableArrayList;

/**
 * Instances of this class represent hands of cards.
 */
public class Hand extends StreamableArrayList<Card>
{
    /**
     * Adds all of the specified cards to this hand.
     */
    @ActionScript(name="addAllCards")
    public void addAll (Card[] cards)
    {
        for (int i = 0; i < cards.length; i++) {
            add(cards[i]);
        }
    }
    
    /**
     * Removes all of the specified cards from this hand.
     */
    @ActionScript(name="removeAllCards")
    public void removeAll (Card[] cards)
    {
        for (int i = 0; i < cards.length; i++) {
            remove(cards[i]);
        }
    }
    
    /**
     * Checks whether this hand contains all of the specified cards.
     */
    @ActionScript(name="containsAllCards")
    public boolean containsAll (Card[] cards)
    {
        for (int i = 0; i < cards.length; i++) {
            if (!contains(cards[i])) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Counts the members of a particular suit within this hand.
     *
     * @param suit the suit of interest
     * @return the number of cards in the specified suit
     */
    public int getSuitMemberCount (int suit)
    {
        int len = size(), members = 0;
        for (int i = 0; i < len; i++) {
            if (((Card)get(i)).getSuit() == suit) {
                members++;
            }
        }
        return members;
    }

    /**
     * Converts this list of cards into an array. This only necessary if you
     * need the cards in array form, use {@link #get} if you simply need to get
     * a card from the hand.
     */
    public Card[] getCards ()
    {
        Card[] cards = new Card[size()];
        toArray(cards);
        return cards;
    }
}
