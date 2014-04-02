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
	 * Riyad YAKINE - ImportManager.as
	 * Seul fichier du package à être en public, c'est lui qui
	 * va chercher les différents appels au loader de fichier,
	 * au parser, au validateur et enfin au créateur de donnée.
	 * L'import manager est directement appelé par le FileManager
	 *****************************************************/
	
	import DataObjects.PlayerCharacter;
	
	import Model.ErrorManager.ErrorManager;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.profiler.showRedrawRegions;
	
	import mx.collections.ArrayCollection;
	
	
	public class ImportManager
	{
		// Nos constantes correspondant au numéro de la première colonne des
		// compétences dans les différents fichier d'imports
		public static var PlayerSkillStartColumnIndex:int = 7;
		public static var CharacterSkillStartColumnIndex:int = 5;
		
		// Instance de notre loader de fichier CSV
		private var locCSVLoader:CSVLoader = new CSVLoader();
		// Variable stockant les compétences propre au casting
		public var castingSkillArray:Array = null;
		// Variable stockant la liste des joueurs du casting
		public var castingHumainPlayerArray:ArrayCollection = new ArrayCollection();
		// Variable stockant la listes des personnages du casting
		public var castingPlayerCharacterArray:ArrayCollection = new ArrayCollection();
		
		public function ImportManager()
		{
		}
		
		/**
		 * Fonction permettant de lancer l'explorateur de fichier pour
		 * importer le fichier de joueurs.
		 * Lors de l'appel à la fonction on créée un eventListener
		 * afin de savoir quand l'utilisateur aura choisi son fichier
		 * puis on ouvre l'explorateur de fichier
		 */
		public function selectPlayerFile():void
		{
			locCSVLoader.csvFile.addEventListener(Event.COMPLETE, importPlayer);
			locCSVLoader.openBroswerFile();
		}
		
		/**
		 * Fonction permettant de lancer l'explorateur de fichier pour
		 * importer le fichier de personnage.
		 * Lors de l'appel à la fonction on créée un eventListener
		 * afin de savoir quand l'utilisateur aura choisi son fichier
		 * puis on ouvre l'explorateur de fichier
		 */
		public function selectCharacterFile():void
		{
			locCSVLoader.csvFile.addEventListener(Event.COMPLETE, importCharacter);
			locCSVLoader.openBroswerFile();
		}
		
		/**
		 * Fonction permettant de récupérer le contenu du fichier
		 * d'import de joueurs choisi par l'utilisateur et de le
		 * transformer en donnée propre à l'application, càd en liste de
		 * joueurs.
		 * Cela s'effectue via l'ImportParser qui va découper le contenu
		 * du fichier en token, puis l'ImportValidator qui vérifiera
		 * la validité de chaque token et enfin l'ImportCreator qui créera
		 * la donnée approprié pour l'application.
		 * Lors de l'appel de à la fonction, on retire l'eventListener
		 * précedemment créée car l'evènement attendu est arrivé. Si on
		 * laisse l'eventListener alors cette fonction sera appelé à chaque
		 * fois qu'un fichier sera chargé dans le CSVLoader
		 */
		public function importPlayer(e:Event):void
		{
			var locPlayerCSVFile:FileReference = null;
			var locPlayerFileTokenArray:Array = null;
			var locPlayerValidateArray:Array = null;
			var locImportValidator:ImportValidator = new ImportValidator();
			var locImportCreator:ImportCreator = new ImportCreator();
			
			locCSVLoader.csvFile.removeEventListener(Event.COMPLETE, importPlayer);
			
			// Import du fichier CSV et stockage du pointeur
			locPlayerCSVFile = locCSVLoader.csvFile;
			
			// Parsing du fichier référencer par le pointeur et stockage du
			// contenu du fichier dans une matrice respectant les lignes et 
			// colonnes du fichier d'origine
			locPlayerFileTokenArray = ImportParser.parseFile(locPlayerCSVFile);
			
			// Validation du format de fichier
			if (!(locImportValidator.playerFileValidator(locPlayerFileTokenArray)))
			{
				return;
			}

			// Récupération des données de la matrice dans les listes de validation
			castingHumainPlayerArray = createCastingPlayerArray(locPlayerFileTokenArray);
			if (castingSkillArray == null)
			{
				castingSkillArray = createCastingSkillArrayFromPlayer(locPlayerFileTokenArray);
			} 
			else 
			{
				if (!(locImportValidator.matchWithCharacterSkillList(locPlayerFileTokenArray,castingSkillArray)))
				{
					return;
				}
			}
			
			// Validation des données et suppression des données eronnées
			locPlayerValidateArray = locImportValidator.importPlayerValidator(locPlayerFileTokenArray,
				castingHumainPlayerArray, castingSkillArray);
			
			// Création des données dans le DataManager à partir des données importées valides
			locImportCreator.createHumanPlayers(locPlayerFileTokenArray);		
		}
		
		/**
		 * Fonction permettant de récupérer le contenu du fichier
		 * d'import de personnages choisi par l'utilisateur et de le
		 * transformer en donnée propre à l'application, càd en liste de
		 * personnage.
		 * Cela s'effectue via l'ImportParser qui va découper le contenu
		 * du fichier en token, puis l'ImportValidator qui vérifiera
		 * la validité de chaque token et enfin l'ImportCreator qui créera
		 * la donnée approprié pour l'application.
		 * Lors de l'appel de à la fonction, on retire l'eventListener
		 * précedemment créée car l'evènement attendu est arrivé. Si on
		 * laisse l'eventListener alors cette fonction sera appelé à chaque
		 * fois qu'un fichier sera chargé dans le CSVLoader
		 */
		public function importCharacter(e:Event):void
		{
			var locCharacterCSVFile:FileReference = null;
			var locCharacterFileTokenArray:Array = null;
			var locCharacterValidateArray:Array = null;
			var locImportValidator:ImportValidator = new ImportValidator();
			var locImportCreator:ImportCreator = new ImportCreator();
			
			// Import du fichier CSV et stockage du pointeur
			locCSVLoader.csvFile.removeEventListener(Event.COMPLETE, importCharacter);
			
			// Parsing du fichier référencer par le pointeur et stockage du
			// contenu du fichier dans une matrice respectant les lignes et 
			// colonnes du fichier d'origine
			locCharacterCSVFile = locCSVLoader.csvFile;
			locCharacterFileTokenArray = ImportParser.parseFile(locCharacterCSVFile);
			
			// Validation du format de fichier
			if (!(locImportValidator.characterFileValidator(locCharacterFileTokenArray)))
			{
				return;
			}
			
			// Récupération des données de la matrice dans les listes de validation
			castingPlayerCharacterArray = createCastingCharacterArray(locCharacterFileTokenArray);
			
			if (castingSkillArray == null)
			{
				castingSkillArray = createCastingSkillArrayFromCharacter(locCharacterFileTokenArray);
			}
			else
			{
				if (!(locImportValidator.matchWithPlayerSkillList(locCharacterFileTokenArray, castingSkillArray)))
				{
					return;
				}
			}
			
			// Validation des données et suppression des données eronnées
			locCharacterValidateArray = locImportValidator.importCharacterValidator(locCharacterFileTokenArray, castingPlayerCharacterArray, castingSkillArray);
			
			// Création des données dans le DataManager à partir des données importées valides
			locImportCreator.createPlayerCharacters(locCharacterFileTokenArray);
		}
		
		/**
		 * Fonction qui retourne la liste des skills contenu dans un fichier d'import
		 * de joueur
		 */
		private function createCastingSkillArrayFromPlayer(playerFileTokenArray:Array):Array
		{
			var locCastingSkillArray:Array = new Array();
			var locSkillLineArray:Array = playerFileTokenArray[0];
			var i:int = PlayerSkillStartColumnIndex;
			
			for (i; i <= locSkillLineArray.length - 1; i++)
			{
				var locCurrentSkill:String = locSkillLineArray[i];
				
				// La dernière compétence est en fin de ligne et contient donc un
				// retour à la ligne que l'on supprime
				if (i == locSkillLineArray.length - 1)
				{
					locCurrentSkill = locCurrentSkill.substr(0, length - 2);
				}
				locCastingSkillArray.push(locCurrentSkill);
				trace ("From Player - Skill " + i + ": [" + locCurrentSkill + "]");
			}
			return locCastingSkillArray;
		}
		
		/**
		 * Fonction qui retourne la liste des skills contenu dans un fichier d'import
		 * de personnage
		 */
		private function createCastingSkillArrayFromCharacter(characterFileTokenArray:Array):Array
		{
			var locCastingSkillArray:Array = new Array();
			var locSkillLineArray:Array = characterFileTokenArray[0];
			var i:int = CharacterSkillStartColumnIndex;
			
			for (i; i <= locSkillLineArray.length - 1; i++)
			{
				var locCurrentSkill:String = locSkillLineArray[i];
			
				// La dernière compétence est en fin de ligne et contient donc un
				// retour à la ligne que l'on supprime
				if (i == locSkillLineArray.length - 1)
				{
					locCurrentSkill = locCurrentSkill.substr(0, length - 2);
				}
				locCastingSkillArray.push(locCurrentSkill);
				trace ("From Character - Skill " + i + ": [" + locCurrentSkill + "]");
			}
			return locCastingSkillArray;
		}
		
		/**
		 * Fonction qui retourne la liste des noms des personnages contenu dans un fichier d'import
		 * de personnage
		 */
		private function createCastingCharacterArray(characterFileTokenArray:Array):ArrayCollection
		{
			var locCastingCharacterArray:ArrayCollection = new ArrayCollection();
			
			// On parcours les lignes de joueurs en commencant par 1 pour
			// sauter la ligne d'en tête
			for (var i:int = 1; i <= characterFileTokenArray.length - 1; i++)
			{
				var locCharacterFullName:String = characterFileTokenArray[i][0].toString() +
					' ' + characterFileTokenArray[i][1].toString();
				
				locCastingCharacterArray.addItem(locCharacterFullName);
				
				trace ("Personnage " + i + ": [" + locCharacterFullName + "]");
			}
			
			return locCastingCharacterArray;
		}
		
		/**
		 * Fonction qui retourne la liste des joueurs contenu dans un fichier d'import
		 * de joueurs
		 */
		private function createCastingPlayerArray(playerFileTokenArray:Array):ArrayCollection
		{
			var locCastingPlayerArray:ArrayCollection = new ArrayCollection();
			
			// On parcours les lignes de joueurs en commencant par 1 pour
			// sauter la ligne d'en tête
			for (var i:int = 1; i <= playerFileTokenArray.length - 1; i++)
			{
				var locPlayerFullName:String = playerFileTokenArray[i][0].toString() +
					' ' + playerFileTokenArray[i][1].toString();
				locCastingPlayerArray.addItem(locPlayerFullName);
				trace ("Joueur " + i + ": [" + locPlayerFullName + "]");
			}
			return locCastingPlayerArray;
		}
	}
}