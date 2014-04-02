package Model.FileManager.ImportManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ImportManager
	 * Le package ImportManager contient l'ensemble des models
	 * interagissant avec l'ImportManager. C'est l'ImportManager
	 * qui va appelé les différents models de traitements pour
	 * charger les fichier, les parser, les valider et créer les
	 * données associées.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - ImportCreator.as
	 * Classe interne au package ImportManager, elle permet de 
	 * transformer les données validées issues du parsing en données
	 * exploitable pour l'application. Pour cela elle crée les
	 * DataObject et les sauvegarde dans le DataManager de
	 * l'application afin de rendre les données accessible à tout
	 * moment que ce soit en lecture ou en écriture. Cette
	 * classe n'est appelé que par l'ImportManager
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	
	import Model.CastingManager.CastingAssociationForbidden;
	import Model.CastingManager.CastingAssociationMendatory;
	import Model.CastingManager.CastingManager;
	import Model.DataManager.DataManager;
	import Model.ErrorManager.ErrorManager;
	
	import mx.collections.ArrayCollection;
	
	
	internal class ImportCreator
	{	
		public function ImportCreator()
		{
			
		}
		
		/**
		 * Fonction qui à partir des données validés va créer la liste de joueurs
		 * participant au casting
		 */
		public function createHumanPlayers(playerFileValidateArray:Array):void
		{
			var locPlayerLineArray:Array = null;
			var locHumanPlayerArray:Array = new Array();
			var i:int = 1;
			
			for (i; i <= playerFileValidateArray.length - 1; i++)
			{
				locPlayerLineArray = playerFileValidateArray[i];
				var locPlayer:HumanPlayer = new HumanPlayer();
				
				locPlayer.firstName = locPlayerLineArray[0];
				locPlayer.lastName = locPlayerLineArray[1];
				locPlayer.idName = locPlayerLineArray[0] + ' ' + locPlayerLineArray[1];
				locPlayer.sex = locPlayerLineArray[2];
				locPlayer.inSameSessionArray = new ArrayCollection(locPlayerLineArray[3]);
				locPlayer.inOtherSessionArray = new ArrayCollection(locPlayerLineArray[4]);
				locPlayer.playWithArray = new ArrayCollection(locPlayerLineArray[5]);
				locPlayer.playWhitoutArray = new ArrayCollection(locPlayerLineArray[6]);
				
				// Import association interdite
				if (ImportManager.PlayerSkillStartColumnIndex == 8)
				{
					locPlayer.notCharacterAssociateArray = new ArrayCollection(locPlayerLineArray[7]);
				}
				
				locPlayer.skillArray = createEntitySkillArray(ImportManager.PlayerSkillStartColumnIndex, locPlayerLineArray.length - 1,	locPlayerLineArray,	playerFileValidateArray[0]);
				
				locHumanPlayerArray.push(locPlayer);
			}
			DataManager.getInstance().humanPlayerArray = new ArrayCollection(locHumanPlayerArray);
			
			// Création Obligation/Interdiction si possible
			if (DataManager.getInstance().originePlayerCharacterArray.length != 0)
			{
				CastingAssociationMendatory.getInstance().createImportMendatoryAssotiation();
				CastingAssociationForbidden.getInstance().createImportForbiddenAssotiation();
				DataManager.getInstance().setSkillCasting();
			}
		}
		
		/**
		 * Fonction qui à partir des données validées va créer la liste des personnages
		 * du casting
		 */ 
		public function createPlayerCharacters(characterFileValidateArray:Array):void
		{
			var locCharacterLineArray:Array = null;
			var locPlayerCharacterArray:Array = new Array();
			var i:int = 1;
			
			for (i; i <= characterFileValidateArray.length - 1; ++i)
			{
				locCharacterLineArray = characterFileValidateArray[i];
				var locCharacter:PlayerCharacter = new PlayerCharacter();
				
				locCharacter.firstName = locCharacterLineArray[0];
				locCharacter.lastName = locCharacterLineArray[1];
				locCharacter.idName = locCharacterLineArray[0] + ' ' + locCharacterLineArray[1];
				locCharacter.sex = locCharacterLineArray[2];
				locCharacter.playWithArray = new ArrayCollection(locCharacterLineArray[3]);
				locCharacter.playWithoutArray = new ArrayCollection(locCharacterLineArray[4]);
				
				// Test nouvelle version de l'import avec joueur obligatoire
				if (ImportManager.CharacterSkillStartColumnIndex >= 6)
				{
					locCharacter.wannaPlayCharacter = new ArrayCollection(locCharacterLineArray[5]);
				}
				// Test nouvelle version de l'import avec joueur facultatif
				if (ImportManager.CharacterSkillStartColumnIndex >= 7)
				{
					if (locCharacterLineArray[6] == "Yes")
					{
						locCharacter.isFacultatif = true;
					}
				}
				
				locCharacter.skillArray = createEntitySkillArray(ImportManager.CharacterSkillStartColumnIndex, locCharacterLineArray.length - 1, locCharacterLineArray,	characterFileValidateArray[0]);
				
				locPlayerCharacterArray.push(locCharacter);
			}
			
			DataManager.getInstance().playerCharacterArray = new ArrayCollection(locPlayerCharacterArray);
			DataManager.getInstance().originePlayerCharacterArray = new ArrayCollection(locPlayerCharacterArray);
			
			// Création Obligation/Interdiction si possible
			if (DataManager.getInstance().humanPlayerArray.length != 0)
			{
				CastingAssociationMendatory.getInstance().createImportMendatoryAssotiation();
				CastingAssociationForbidden.getInstance().createImportForbiddenAssotiation();
				DataManager.getInstance().setSkillCasting();
			}
		}
		
		/**
		 * Fonction qui va créer les différentes listes de session avec/sans et joue avec/sans pour un joueur
		 */
		private function createPlayerArrayForPlayer(playerListStartColumnIndex:int, playerListEndColumnIndex:int, playerLineArray:Array):Array
		{
			return new Array();
		}
		
		/**
		 * Fonction qui va créer la liste des compétences de chaque entité (joueur ou personnage)
		 */
		private function createEntitySkillArray(skillStartColumnIndex:int, skillEndColumnIndex:int, entityLineArray:Array, skillLineArray:Array):ArrayCollection
		{
			var locEntitySkillArray:ArrayCollection = new ArrayCollection();
			var i:int = skillStartColumnIndex; 
			
			for (i; i <= skillEndColumnIndex; i++)
			{
				var locSkill:Skill = new Skill();
				locSkill.name = formatSkillName(skillLineArray[i]);
				locSkill.capacity = entityLineArray[i];
				locEntitySkillArray.addItem(locSkill);
			}
			
			return locEntitySkillArray;
		}
		
		/** DOCUMENTATION
		 * Fonction qui formate le nom d'une competence
		 * @param String le nom actuel de la competence
		 * @return String le nom de cette competence formate
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		private function formatSkillName(parSkillName:String):String
		{
			var locResult:String = "";
			var locSize:int = parSkillName.length;
			
			if (parSkillName.charAt(locSize - 1) == "\r")
			{
				locResult += parSkillName.substr(0, locSize - 1);
			}
			else
			{
				locResult += parSkillName;		
			}
			
			return locResult;
		}
	}
}