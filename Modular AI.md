Modular AI

GAIA is a straightforward enough system. You first implement an interface through which each NPC is going to interact with these behaviour trees. Then you build the interface for each NPC through a series of modules.
These modules are made up of Reasoners which take in Considerations to select from its Options. Its Options may lead to further Reasoner Modules or lead to direct Actions or a mix of both. We'll need a weight function
for this and I think the best way to do that is to ascribe a value to each Option. It should check its Options in the immediate scenario and predict what its scenario will be in a couple seconds from now to determine 
what option has the most value I think. We can start with the first pass implementation then add a second pass to refine if its not too computationally expensive. All of these functions need to be Async and able to
be interrupted by signals. 

We are not going to be doing a straight GAIA implementation, as its a data-driven pre-defined system. It takes in XMLs to build out its considerations and weights which is not something we want. We need AI to be 
able to change weights based on changing circumstances and we can probably do all that in real time. NPCs should have a list of contacts which stores the information they know about in the world map which must
be distinct from the global knowledge. An NPC has a more limited range of vision and only knows what it sees or what the player tells it. A list of threats might also be useful as a distinct set of contacts
that the NPC is more likely to respond to and act upon. 