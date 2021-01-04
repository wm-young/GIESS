# GIESS
Galaxy Identification Expert System Shell
(GIESS)

Michael Young 424718
COSC 4P79 Final Project
May 2012


Introduction

	For my expert system I chose to make a system similar to the native expert system shell. The purpose of this system is to name or label galaxies by simply explaining the defining characteristics of each. It uses a backward chaining inference engine to gather rules and facts in order to solve the top goal, which is identifying a galaxy.

How to Use GIESS

	All commands are represented in brackets as such, [command.]. The brackets are there only to distinguish that it is a command and if you were to type it into the shell, it will be recognized. Of course the typed commands themselves do not have brackets. If the user wishes to see more information about each command, then he or she must simply type 'help.', without the quotations and remembering the period. 

	On start-up a list of commands is displayed to the user telling them how to interact with GIESS. The user can always type [help.] to see a list of all the commands and more information about each.

1. To start the program, load up GIESS with SWI-Prolog interpreter and type 'main'. This starts the main program and allows the user to fully use GIESS. A command menu is displayed once GIESS has started.

2.Load in the knowledge base by typing in [load.]. In our case, the knowledge base is called "galaxy.nkb". Type 'galaxy.nkb' with single quotes to connect the shell with the knowledge base.

3.Now that the shell has access to the knowledge base, the user can type how, why, whynot or dump 
certain goals. To start the inference engine type 'solve.' and answer the corresponding questions to 
determine what galaxy it is you're trying to identify.


Domain

	Galaxy classification and identification can be rather complex, seeing as how there are so many galaxies in the universe, it's almost impossible to uniquely identify all of them. Obviously, there is no way to include all of the galaxies in my knowledge base, but I included a bunch that have unique features are strongly represent their class group.

	This idea extends from Galaxy Zoo[1], which is an online galaxy classification program that NASA has made to allow amateur astronomers(or even new recruits!) to view pictures of galaxies and narrow down the classification for NASA to keep in their database. 

	I used this classification system to get a good line of reasoning for galaxy classification, but my classification structure actually comes from Edwin Hubble's Classification Scheme [2].

	This is the basic layout of the classification called Hubble Tuning Fork. This breaks galaxies down into two(technically 3) different categories – elliptical, spiral, lenticular. 

	The first, on the far left coloured blue are the elliptical classifications. This is denoted by E and a number 0,3,5 or 7 depending on the shape of the elliptical galaxy- 0 being round and 7 being a more stretched out - cigar shape. 

	S denotes a spiral galaxy. It is followed by either 0, a,b or c, depending on the “tightness” of the arms, a being tightly bound arms and c being loosely bound.

	SB denotes a spiral galaxy that has a bar through it. This bar represents a line or cluster of stars that can form in some galaxies depending on various reasons and behavior of each. Again, a,b and c denote the bars shape and effect on the galaxies arms.

	Lenticular galaxies and almost a cross between elliptical and spiral. By this classification scheme, lenticular galaxies are denoted by S0, usually meaning they are of some irregular shape or do not have a definite characteristic. 

	The only issue with this classification is that it doesn't fully classify all galaxies, actually there are a lot of holes in this scheme causing numerous galaxies to fall under irregular or lenticular when they should be classified as something else. Gerard de Vaucouleurs came up with the Near-Infrared Galaxy Morphology scheme which extends Hubble's Scheme by adding a bit more detail in the classification. 	

	One case see the similarities between the two schemes, however  de Vaucouleur's scheme includes an intermediate stage up spiral galaxies SAB, where the galaxy does not have a definitive bar through it or does not have a clear nucleus and well defined arms.  It also take in to account the size and distributions of all the stars, but for our purpose this is unnecessary.

Example Classification

 To give a feel for how the classifying works, let's take a look at an example. The image below is a picture of the Milky Way galaxy, which happens to be the galaxy where our own solar system is located. 

	Right away it's obvious that it is a spiral galaxy. You can plainly see the arms and spiral effect. If you look in the center of the galaxy, there is a well defined bar effect happening. With this information alone, we can classify is as a barred spiral galaxy, SB. Determining the tightness of the arms can be rather difficult, especially if you don't have anything to compare it to. With a bit of experience one can quickly jump to these conclusions, but in a case like this, it's hard to say if the arms are medium bound or loosely bound. It's actually an in-between value, however my expert system does not have that many discrete values for this type of classification. In this case the arms are considered to be loosely bound and therefore the proper classification of this galaxy is SBc.

	It's also worth mentioning that the number of arms and direction of the arms plays a large role in identifying, strictly between spiral galaxies. There are 4 arms in the milky way galaxy. If you look closely, you can see the two bit arms jutting out from the center and wrapping around to create the spiral effect, but if you look closer, you can two little arms that also stick our from the center. They are easier to see if you look at the ends of the arms where they are spiraling around and you can see the definite 4 arm architecture.


Example of Program Outputs

 a. Inference Example

The following is a copied segment from the output of GIESS in the SWI interpreter. This example shows how the identification of the Milky Way galaxy is done.

*************************
*** Welcome to GIESS! ***
*************************

The expert system shell that allows the user to classify galaxies!.

Start by typing one of the following commands at the prompt. Type help. for more information about each command.
To load your knowledge base right away, type [load.] without quotes at the prompt.
[help.] [dump.] [trace.] [load.] [solve.] [how(Goal).] [why.] [whynot(Goal)] [quit.]
$> load.
Enter file name in single quotes (ex. 'galaxy.nkb'.): 'galaxy.nkb'.
% galaxy.nkb compiled 0.00 sec, 8,260 bytes
Type [solve.] to start the inference engine$> solve.
shape:spiral? (yes or no) $> yes.
is_barred:yes? (yes or no) $> yes.

What is the value for arm_configuration?
1  : tighly_bound
2  : medium_bound
3  : loosely_bound
4  : none
Enter the number of your choice> $> 3.


What is the value for number_of_arms?
1  : 1
2  : 2
3  : 3
4  : four
5  : 5
6  : 6
Enter the number of your choice> $> 4.

arm_direction:clockwise? (yes or no) $> yes.
bulge:small? (yes or no) $> yes.
The answer is milky_way

 b. Dump
galaxy(milky_way) if class(barred_spiral) and 
 if arm_configuration(loosely_bound) and 
 if number_of_arms(4) and 
 if arm_direction(clockwise) and 
bulge(small

 c. Why
shape:spiral? (yes or no) $> why.
Want to see if it's class(barred_spiral)

 d. How
$> how(galaxy(andromeda)).
Because the class(spiral)
    and the arm_configuration(medium_bound)
    and the bulge(small)
it follows that galaxy(andromeda) 


 e. Help
*** Help ***
Type in any one of the following commands at the prompt in order to communicate with the expert system.
        [help.] - Displays the list of commands.
        [dump(Goal).] - Dumps the current execution tree of the given Goal
        [trace.] - Enables or disables tracing in the expert system chain of reasoning.
        [load.] - Tells the expert system you wish to load a knowledge base. Afterwards you will be prompted for the knowledge base name
        [solve.] - Starts the line of reasoning.
        [how(Goal).]- Explains how a certain goal was solved.
        [why.] - Explains why a certain goal was solved. Continuous querying results in hierarchical explanation of goals.
        [whynot(Goal).] - Explains why a certain goal was not solved.
        [quit.] - Quits and closes the expert system and the working knowledge base if there is one.
**


Things to Note

	I had included in my code rules for each location of a galaxy. These rules included which supercluster and local cluster the galaxy is in. This information is not always known to the amateur astronomer, or even the expert astronomer! I made the decision to not include location because in this case it will not help the chaining of reasoning at all. However, if the user did know where the galaxy was located but still wanted to identify it, then this is valuable information that can lead to proper identification of a galaxy. Maybe for future version of GIESS I can include a toggle command that lets the user decided if they want to narrow the identification down by location of the galaxy or not.

	I didn't have access to an expert on galaxies, so I did the best I could to learn how a galaxy is classified and what are some of the main attributes that define a galaxy. I think with an experts opinion, GIESS can be altered in such a way to maybe included x-ray image information about each galaxy or even their redshift(caused by the Doppler Effect by expanded space) to help more accurately define galaxies. Of course with my current knowledge base this is slightly unnecessary, but if we were to extend the knowledge base, then we would need to include more specific rules for each galaxy. 

References

[1] - www.galaxyzoo.org

[2] - http://en.wikipedia.org/wiki/Galaxy_morphological_classification

[3] - http://www.ehow.com/info_8613494_scientists-able-classify-galaxies.html

[4] - http://cse.ssl.berkeley.edu/segwayed/lessons/classifying_galaxies/student2.htm

Answers
Example 1- Messier 83
Example 2- Andromeda
Example 3- Centaurus A