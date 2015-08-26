###
Crafting Guide - crafting_plan_node.coffee

Copyright (c) 2015 by Redwood Labs
All rights reserved.
###

CraftingNode = require './crafting_node'
ItemNode     = require './item_node'

########################################################################################################################

module.exports = class InventoryNode extends CraftingNode

    constructor: (options={})->
        if not options.inventory? then throw new Error 'options.inventory is required'
        super options

        @inventory = options.inventory

    # CraftingNode Overrides #######################################################################

    _createChildren: (result=[])->
        @inventory.each (stack)=>
            item = @modPack.findItem stack.itemSlug
            if not item? then throw new Error "Could not find an item for slug: #{stack.itemSlug}"
            result.push new ItemNode modPack:@modPack, item:item
        return result

    _checkCompleteness: ->
        for child in @children
            return false unless child.isComplete
        return true

    _checkValidity: ->
        for child in @children
            return false unless child.isValid

    # Object Overrides #############################################################################

    toString: (indent='')->
        completeText = if @complete then 'complete' else 'incomplete'
        parts = ["#{indent}#{@completeText} InventoryNode for #{@inventory}"]
        nextIndent = indent + '    '
        for child in @children
            parts.push child.toString nextIndent
        return parts.join '\n'