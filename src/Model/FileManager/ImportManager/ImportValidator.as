package Model.FileManager.ImportManager
{
	import Model.DataManager.DataManager;
	import Model.ErrorManager.ErrorManager;
	
	import mx.collections.ArrayCollection;
	
	
	/**Description
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ImportManager
	 * Le package ImportManager contient l'ensemble des models
	 * interagissant avec l'ImportManager. C'est l'ImportManager
	 * qui va appelé les différents models de traitements pour
	 * charger les fichier, les parser, les valider et créer les
	 * données associées.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - ImportValidator.as
	 * Classe interne au package ImportManager, elle permet de 
	 * validées les données issues du découpage en token fait
	 * par l'ImportParser. Cette classe ne communique qu'à travers
	 * l'ImportManager
	 *****************************************************/
	
	internal class ImportValidator
	{
		public function ImportValidator()
		{
		}
		
		/**
		 * Fonction permettant de lancer l'ensemble des validateurs sur l'import de
		 * joueurs et de renvoyer une matrice de données validées.
		 * C'est cette fonction qui est appelé par l'ImportManager
		 */
		public function importPlayerValidator(playerFileTokenArray:Array,
											  castingHumanPlayerArray:ArrayCollection,
											  castingSkillArray:Array):Array
		{
			var locPlayerFileTokenArray:Array = new Array();
			
			locPlayerFileTokenArray = checkPlayerArrayFromPlayerFileTokenArray(playerFileTokenArray,
				castingHumanPlayerArray);
			
			locPlayerFileTokenArray = checkSkillFromPlayerFileTokenArray(playerFileTokenArray);
			
			return locPlayerFileTokenArray;
		}
		
		/**
		 * Fonction permettant de lancer l'ensemble des validateurs sur l'import de
		 * personnages et de renvoyer une matrice de données validées.
		 * C'est cette fonction qui est appelé par l'ImportManager
		 */
		public function importCharacterValidator(characterFileTokenArray:Array,
												 castingPlayerCharacterArray:ArrayCollection,
												 castingSkillArray:Array):Array
		{
			var locCharacterFileTokenArray:Array = new Array();
			
			locCharacterFileTokenArray = checkCharacterArrayFromCharacterFileTokenArray(characterFileTokenArray,
				castingPlayerCharacterArray);
			
			locCharacterFileTokenArray = checkSkillFromCharacterFileTokenArray(characterFileTokenArray);
			
			return locCharacterFileTokenArray;
		}
		
		/**
		 * Fonction permettant de vérifier si le type de fichier d'import utilisé
		 * est bien un fichier d'import de joueurs et si il respecte le format
		 * attendu
		 */
		public function playerFileValidator(playerFileTokenArray:Array):Boolean
		{
			var locCategoryLineArray:Array = playerFileTokenArray[0];
			
			if ((locCategoryLineArray[0] == "Prénom") &&
				(locCategoryLineArray[1] == "Nom") &&
				(locCategoryLineArray[2] == "Sexe") &&
				(locCategoryLineArray[3] == "Session avec") &&
				(locCategoryLineArray[4] == "Session sans") &&
				(locCategoryLineArray[5] == "Joue avec") &&
				(locCategoryLineArray[6] == "Joue sans"))
			{
				// Vérification premier changement fichier importation
				if (locCategoryLineArray[7] == "Joueur interdit")
				{	
					if (locCategoryLineArray[8] == "Jouer avec obligatoire")
					{
						ImportManager.PlayerSkillStartColumnIndex = 9;
					}
					else
					{
						ImportManager.PlayerSkillStartColumnIndex = 8;		
					}
				}
				
				ErrorManager.getInstance().addImportErrorMessage("OK: Le fichier importé correspond bien au modèle de fichier d'import de joueur");
				
				return true;
			}
			ErrorManager.getInstance().addImportErrorMessage("GRAVE-Importation annulée: Le fichier importé ne correspond pas au fichier d'import de joueur standard. Merci de télécharger le modèle de fichier d'import de joueur.");
			return false;
		}
		
		/**
		 * Fonction permettant de vérifier si le type de fichier d'import utilisé
		 * est bien un fichier d'import de personnages et si il respecte le format
		 * attendu
		 */
		public function characterFileValidator(characterFileTokenArray:Array):Boolean
		{
			var locCategoryLineArray:Array = characterFileTokenArray[0];
			
			if ((locCategoryLineArray[0] == "Prénom") &&
				(locCategoryLineArray[1] == "Nom") &&
				(locCategoryLineArray[2] == "Sexe") &&
				(locCategoryLineArray[3] == "Joue avec") &&
				(locCategoryLineArray[4] == "Joue sans"))
			{
				// Vérification premier changement fichier importation
				if (locCategoryLineArray[5] == "Joueur prefere")
				{	
					if (locCategoryLineArray[6] == "Joueur facultatif")
					{
						ImportManager.CharacterSkillStartColumnIndex = 7;
					}
					else
					{
						ImportManager.CharacterSkillStartColumnIndex = 6;		
					}
				}
				
				ErrorManager.getInstance().addImportErrorMessage("OK: Le fichier importé correspond bien au modèle de fichier d'import de personnage");
				
				return true;
			}
			ErrorManager.getInstance().addImportErrorMessage("GRAVE-Importation annulée: Le fichier importé ne correspond pas au fichier d'import de personnages standard. Merci de télécharger le modèle de fichier d'import de personnages.");
			return false;
		}
		
		/**
		 * Fonction permettant de vérifier si le type de fichier d'import utilisé
		 * est bien un fichier d'import de résultats et si il respecte le format
		 * attendu
		 */
		public function resultFileValidator():Boolean
		{
			return true;	
		}
		
		/**
		 * Fonction qui détermine si le score d'une capacité est dans l'intervalle
		 * attendue et la remet à 100 (neutre) sinon.
		 */
		public function isValidSkillCapacity(skillCapacity:int):String
		{
			if ((skillCapacity < 0) || (skillCapacity > 100))
			{
				ErrorManager.getInstance().addImportErrorMessage("Anodine: La capacité de la compétence est hors bornes [0-100], celle-ci à été ramené à 100.");
				
				if (skillCapacity < 0)
					return "0";
				
				if (skillCapacity > 100)
					return "100";
			}
			return skillCapacity.toString();
		}
		
		/** DOCUMENTATION
		 * Fonction qui creer un model de fichier d'un personage
		 * @param void
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function checkSkillFromPlayerFileTokenArray(playerFileTokenArray:Array):Array
		{
			var locNewPlayerFileTokenArray:Array = playerFileTokenArray;
			
			for (var i:int = 1; i <= playerFileTokenArray.length - 1; i++)
			{
				var locCurrentPlayerLine:Array = locNewPlayerFileTokenArray[i];
				
				trace ("Pour le joueur : [" + locCurrentPlayerLine[0] + " " + locCurrentPlayerLine[1] + "]");
				
				for (var j:int = ImportManager.PlayerSkillStartColumnIndex; j <= locCurrentPlayerLine.length - 1; j++)
				{
					var locCurrentSkill:String = isValidSkillCapacity(locCurrentPlayerLine[j]);
					locCurrentPlayerLine[j] = locCurrentSkill;
				}
				locNewPlayerFileTokenArray[i] = locCurrentPlayerLine;
			}
			trace ("OK: L'ensemble des capacitées des compétences des joueurs sont validés");
			return locNewPlayerFileTokenArray;
		}
		
		public function checkSkillFromCharacterFileTokenArray(characterFileTokenArray:Array):Array
		{
			var locNewCharacterFileTokenArray:Array = characterFileTokenArray;
			
			for (var i:int = 1; i <= characterFileTokenArray.length - 1; i++)
			{
				var locCurrentCharacterLine:Array = locNewCharacterFileTokenArray[i];
				
				trace ("Pour le personnage : [" + locCurrentCharacterLine[0] + " " + locCurrentCharacterLine[1] + "]");
				
				for (var j:int = ImportManager.CharacterSkillStartColumnIndex; j <= locCurrentCharacterLine.length - 1; j++)
				{
					var locCurrentSkill:String = isValidSkillCapacity(locCurrentCharacterLine[j]);
					locCurrentCharacterLine[j] = locCurrentSkill;
				}
				
				locNewCharacterFileTokenArray[i] = locCurrentCharacterLine;
			}
			trace ("OK: L'ensemble des capacitées des compétences des personnages sont validés");
			return locNewCharacterFileTokenArray;
		}
		
		/**
		 * Fonction prenant une liste de joueurs formaté et renvoyant une liste
		 * de joueurs validé.
		 */
		public function isValidPlayerArray(playerArray:Array,
										   castingHumanPlayerArray:ArrayCollection):Array
		{
			var locPlayerArray:Array = new Array();
			
			for (var i:int = 0; i <= playerArray.length - 1; i++)
			{
				var locCurrentPlayer:String = playerArray[i];
				
				if (castingHumanPlayerArray.contains(locCurrentPlayer))
				{
					trace (i + ": [" + locCurrentPlayer + "] ajouté à la liste de joueurs");
					locPlayerArray.push(locCurrentPlayer);
				}
				else
				{
					ErrorManager.getInstance().addImportErrorMessage("Anodine: Le joueur [" + locCurrentPlayer + "] ne correspond à aucun joueur du casting, celui-ci est supprimer de la liste courante.");
				}
			}
			return locPlayerArray;
		}
		
		public function checkPlayerArrayFromPlayerFileTokenArray(playerFileTokenArray:Array,
																 castingHumanPlayerArray:ArrayCollection):Array
		{
			var locNewPlayerFileTokenArray:Array = playerFileTokenArray;
			
			for (var i:int = 1; i <= playerFileTokenArray.length - 1; i++)
			{
				var locCurrentPlayerLine:Array = locNewPlayerFileTokenArray[i];
				
				trace ("Pour le joueur : [" + locCurrentPlayerLine[0] + " " + locCurrentPlayerLine[1] + "]");
				
				for (var j:int = 3; j < ImportManager.PlayerSkillStartColumnIndex; j++)
				{
					var locCurrentPlayerList:Array = isValidPlayerArray(formatEntityList(locCurrentPlayerLine[j]), castingHumanPlayerArray);
					locCurrentPlayerLine[j] = locCurrentPlayerList;
				}
				
				locNewPlayerFileTokenArray[i] = locCurrentPlayerLine;
			}
			ErrorManager.getInstance().addImportErrorMessage("OK: L'ensemble des listes de joueurs sont validés");
			return locNewPlayerFileTokenArray;
		}
		
		/**
		 * Fonction prenant une liste de joueurs formaté et renvoyant une liste
		 * de joueurs validé.
		 */
		public function isValidCharacterArray(characterArray:Array,
											  castingPlayerCharacterArray:ArrayCollection, parIndex:int = 0):Array
		{
			var locCharacterArray:Array = new Array();
			
			for (var i:int = 0; i <= characterArray.length - 1; i++)
			{
				var locCurrentCharacter:String = characterArray[i];
				
				if (castingPlayerCharacterArray.contains(locCurrentCharacter) || parIndex > 4)
				{
					trace (i + ": [" + locCurrentCharacter + "] ajouté à la liste de personnages");
					
					locCharacterArray.push(locCurrentCharacter);
				}
				else
				{
					ErrorManager.getInstance().addImportErrorMessage("Anodine: Le personnage " + locCurrentCharacter + " ne correspond à aucun personnage du casting, celui-ci est supprimer de la liste courante.");
				}
			}
			return locCharacterArray;
		}
		
		public function checkCharacterArrayFromCharacterFileTokenArray(characterFileTokenArray:Array,
																	   castingPlayerCharacterArray:ArrayCollection):Array
		{
			var locNewCharacterFileTokenArray:Array = characterFileTokenArray;
			
			for (var i:int = 1; i <= characterFileTokenArray.length - 1; i++)
			{
				var locCurrentCharacterLine:Array = locNewCharacterFileTokenArray[i];
				
				trace ("Pour le personnage: [" + locCurrentCharacterLine[0] + " " + locCurrentCharacterLine[1] + "]");
				
				for (var j:int = 3; j < ImportManager.CharacterSkillStartColumnIndex; j++)
				{
					var locCurrentCharacterList:Array = isValidCharacterArray(formatEntityList(locCurrentCharacterLine[j]), castingPlayerCharacterArray, j);
					
					locCurrentCharacterLine[j] = locCurrentCharacterList;
				}
				
				locNewCharacterFileTokenArray[i] = locCurrentCharacterLine;
			}
			
			ErrorManager.getInstance().addImportErrorMessage("OK: L'ensemble des listes de personnages sont validés");
			
			return locNewCharacterFileTokenArray;
		}
		
		/**
		 * Fonction permettant de transformer le contenu d'une liste d'entité
		 * (joueurs ou personnage) utilisés pour décrire les cases (joue avec/sans
		 * et session avec/sans) dans un tableau sans erreur d'interprétation possible
		 * à savoir : prénom_nom (ou le caractère underscore représente un espace)
		 */
		public function formatEntityList(entityList:String):Array
		{
			var locEntityArrayTmp:Array = entityList.split(',');
			var locWhitespaceRegExp:RegExp = /(\s{2,})/g;
			var locEntityArray:Array = new Array();
			
			for( var i:int = 0; i <= locEntityArrayTmp.length - 1; i++)
			{
				var locEntity:String = locEntityArrayTmp[i];
				if (locEntity.length > 0)
				{
					locEntity = locEntity.replace(locWhitespaceRegExp, ' ');
					if (locEntity.charAt(0) == ' ')
					{
						locEntity = locEntity.substr(1,locEntity.length - 1);
					}
					if (locEntity.charAt(locEntity.length - 1) == ' ')
					{
						locEntity = locEntity.substr(0,locEntity.length - 2);
					}
					locEntityArray.push(locEntity);
				}
			}		
			return locEntityArray;
		}
		
		/**
		 * Fonction qui permet de vérifier si la liste de compétences des personnages
		 * correspond à la liste de compétences des joueurs
		 */
		public function matchWithPlayerSkillList(characterFileTokenArray:Array, castingSkillArray:Array):Boolean
		{
			var locSkillLineArray:Array = characterFileTokenArray[0];
			var i:int = ImportManager.CharacterSkillStartColumnIndex;
			var locCharacterSkillStartColumnIndex:int = ImportManager.CharacterSkillStartColumnIndex;
			
			for (i; i <= locSkillLineArray.length - 1; i++)
			{
				var locCurrentSkill:String = locSkillLineArray[i];
				var locCastingSkill:String = castingSkillArray[i - locCharacterSkillStartColumnIndex];
				
				// La dernière compétence est en fin de ligne et contient donc un
				// retour à la ligne que l'on supprime
				if (i == locSkillLineArray.length - 1)
				{
					locCurrentSkill = locCurrentSkill.substr(0, length - 2);
				}
				
				trace ("Skill From Character: [" + locCurrentSkill + "] | Skill From Casting: [" + locCastingSkill + "]");
				
				if (locCurrentSkill != locCastingSkill)
				{
					ErrorManager.getInstance().addImportErrorMessage("GRAVE-Importation annulée: La liste des compétences des personnages ne correspond pas à la liste des compétences des joueurs. [" + locCurrentSkill + "] devrait correspondre à [" + locCastingSkill +"].");
					return false;
				}
			}
			
			ErrorManager.getInstance().addImportErrorMessage("OK: La liste des skill provenant du fichier d'import des personnages est valide.");
			
			return true;
		}
		
		/**
		 * Fonction qui permet de vérifier si la liste de compétences des joueurs
		 * correspond à la liste de compétences des personnages
		 */
		public function matchWithCharacterSkillList(playerFileTokenArray:Array, castingSkillArray:Array):Boolean
		{		
			var locSkillLineArray:Array = playerFileTokenArray[0];
			var i:int = ImportManager.PlayerSkillStartColumnIndex;
			var locPlayerSkillStartColumnIndex:int = ImportManager.PlayerSkillStartColumnIndex;
			
			for (i; i <= locSkillLineArray.length - 1; i++)
			{
				var locCurrentSkill:String = locSkillLineArray[i];
				var locCastingSkill:String = castingSkillArray[i - locPlayerSkillStartColumnIndex];
				
				// La dernière compétence est en fin de ligne et contient donc un
				// retour à la ligne que l'on supprime
				if (i == locSkillLineArray.length - 1)
				{
					trace ("Dernier skill du fichier avant transformation: [" + locCurrentSkill + "]");
					locCurrentSkill = locCurrentSkill.substr(0, length - 2);
					trace ("Dernier skill du fichier après transformation: [" + locCurrentSkill + "]");
				}
				
				trace ("Skill From Player: [" + locCurrentSkill + "] | Skill From Casting: [" + locCastingSkill + "]");
				
				if (locCurrentSkill != locCastingSkill)
				{
					ErrorManager.getInstance().addImportErrorMessage("GRAVE-Importation annulée: La liste des compétences des joueurs ne correspond pas à la liste des compétences des personnages. [" + locCurrentSkill + "] devrait correspondre à [" + locCastingSkill +"].");
					return false;
				}
			}
			
			ErrorManager.getInstance().addImportErrorMessage("OK: La liste des skill provenant du fichier d'import des joueurs est valide.");
			return true;
		}
	}
}