#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "PlaylistNode.h"

void SetPlaylistNode(PlaylistNode* thisNode, char idInit[], char songNameInit[], char artistNameInit[], int songLengthInit){
	
	strcpy(thisNode->uniqueID, &idInit[50]);
	strcpy(thisNode->songName, &songNameInit[50]);
	strcpy(thisNode->artistName, &artistNameInit[50]);
	thisNode->songLength = songLengthInit;
	thisNode->nextNodePtr = NULL;
}

void PrintPlaylistNode(PlaylistNode* thisNode){
	printf("Unique ID: %c\n ", *thisNode->uniqueID);
	printf("Song Name: %c\n ", *thisNode->songName);
	printf("Artist Name: %c\n ", *thisNode->artistName);
	printf("Song Length (in seconds): %d\n ", thisNode->songLength);
}

PlaylistNode* GetNextPlaylistNode(PlaylistNode* thisNode){
	return thisNode->nextNodePtr; 
}
