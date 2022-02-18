#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "PlaylistNode.h"

void PrintMenu(char playlistName[50]){
	printf("%s PLAYLIST MENU\n",&playlistName[50]);
	printf("a - Add song\n");
	printf("r - Remove song\n");
	printf("o - Output full playlist\n");
	printf("q - Quit\n\n");
}

PlaylistNode* ExecuteMenu(char menuInput, char playlistName[], PlaylistNode* headNode){
	
	
	switch (menuInput) {
		case 'a': ;
			char uniqueID[50];
			char songName[50];
			char artistName[50];
			int songLength;
			PlaylistNode* newNode = (PlaylistNode*)malloc(sizeof(PlaylistNode));
			printf("Enter song's Unique ID: ");
			scanf(" %s", &uniqueID[50]);
			printf("Enter song name: ");
			scanf(" %s", &songName[50]);
			printf("Enter artist's name: ");
			scanf(" %s", &artistName[50]);
			printf("Enter song's length (in seconds): ");
			scanf(" %d", &songLength);
			SetPlaylistNode(newNode, uniqueID, songName, artistName, songLength);
			break;
	
		
		case 'r': ;
			PlaylistNode* thisNode = GetNextPlaylistNode(headNode);
			char removalID[50];
			printf("Enter song's unique ID: ");
			scanf(" %s", &removalID[50]);
			while(thisNode->uniqueID != removalID){
				GetNextPlaylistNode(thisNode);
			}
			
			
			
		case 'o': ;
		
			if(GetNextPlaylistNode(thisNode) == NULL){
				printf("Playlist is empty.\n");
			}
			else{
				int count = 0;
				PlaylistNode* thisNode = headNode->nextNodePtr;
				while(GetNextPlaylistNode(thisNode) != NULL){
					printf("%d\n", count);
					PrintPlaylistNode(thisNode);
					thisNode = thisNode->nextNodePtr;
					count++;
				}
			}
			break;
		}
		return headNode;
}


int main() {
	PlaylistNode* headNode = NULL;
	
	
	char playlistName[50];
	printf("Enter playlist's title:\n");
	scanf("%s", &playlistName[50]);
	playlistName[strlen(playlistName) - 1] = '\0';
	PrintMenu(playlistName);
	
	
	char menuInput;
	while(menuInput != 'q'){
		printf("Choose an option:\n");
		scanf("%s", &menuInput);
		if (menuInput == 'a' || menuInput == 'r' || menuInput == 'o'){
			headNode = ExecuteMenu(menuInput, playlistName, headNode);
			PrintMenu(playlistName);
		}
	}
	

	return 0;
}
