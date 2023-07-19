class_name Attack
extends Node

var range
var attack_speed
var physical
var magic
var fire
var air
var earth 
var water
var light
var shadow
var nature
var electric


func initialize(definition: Resource):
	self.range = definition.range 
	self.attack_speed =  definition.attack_speed 
	self.physical = definition.physical 
	self.magic = definition.magic 
	self.fire = definition.fire 
	self.air = definition.air 
	self.earth = definition.earth  
	self.water = definition.water 
	self.light = definition.light 
	self.shadow = definition.shadow 
	self.nature = definition.nature 
	self.electric = definition.electric 

