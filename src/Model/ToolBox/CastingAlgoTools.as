package Model.ToolBox
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package ToolBox
	 * Le package ToolBox contient l'ensemble des fonctions
	 * utilisables un peu partout dans le projet
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CastingAlgoTools.as
	 * Classe qui contient plusieus fonctions utiles pour les
	 * algos d'association du casting
	 *****************************************************/
	
	import DataObjects.Entity;
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	
	import Model.AlgoManager.AlgoParam;
	import Model.CastingManager.CastingAssociation;
	import Model.CastingManager.CastingAssociationCalculator;
	import Model.CastingManager.CastingManager;
	import Model.CastingManager.CastingSession;
	import Model.DataManager.DataManager;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class CastingAlgoTools
	{
		public function CastingAlgoTools()
		{
		}
		
		/** DOCUMENTATION:
		 * Fonction qui indique si un personnage et un joueur ne sont pas du même sexe
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * @return Boolean Vrai si le personnage et le joueur ne sont pas du même sexe, faux sinon
		 */
		public static function isNotSameSex(parCastingAssociation:CastingAssociation):Boolean
		{
			if (parCastingAssociation._playerCharacter.sex == "N")
				return false;
			else {
				if (parCastingAssociation._playerCharacter.sex == parCastingAssociation._humanPlayer.sex)
					return false;
				else
					return true;
			}
		}
		
		/** DOCUMENTATION:
		 * Fonction qui indique si une association est disponible
		 * @since 2011/10/13
		 * @author Riyad YAKINE
		 * @param CastingAssociation L'association personnage/joueur
		 * @return Boolean Vrai si le joueur est toujours disponible pour l'association Faux sinon
		 */
		public static function isAssociationAvailable(parCastingAssociation:CastingAssociation):Boolean
		{
			return parCastingAssociation._humanPlayer.available;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui construit une copie du tableau de personnages du DataManager
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @return Array La copie du tableau de personnages
		 * */
		public static function buildPlayerCharacterArray():Array
		{
			var locPlayerCharacterArray:Array = [];
			var locDataManager:DataManager = DataManager.getInstance();
			var locArraySize:int = locDataManager.playerCharacterArray.length;
			
			for (var i:int = 0; i < locArraySize; i++)
			{
				var locPlayerCharacter:PlayerCharacter = new PlayerCharacter();
				var locTmpPlayerCharacter:PlayerCharacter = locDataManager.playerCharacterArray[i] as PlayerCharacter;
				
				copyPlayerCharacter(locTmpPlayerCharacter, locPlayerCharacter);
				locPlayerCharacterArray.push(locPlayerCharacter);
			}
			return (locPlayerCharacterArray);
		}
		
		/** DOCUMENTATION:
		 * Fonction qui duplique le tableau de personnages du DataManager selon le nombre de sessions désirées
		 * L'id du personnage est modifié afin de faire aparaître dans le nom le nombre de session
		 * @since 2011/12/08
		 * @author Riyad YAKINE
		 * @param Int Le nombre de session a créer
		 * */
		public static function buildPlayerCharacterArrayFromSessionNumber(parSessionNumber:int):void
		{
			var locDataManager:DataManager = DataManager.getInstance();
			var locPlayerCharacterArray:ArrayCollection = new ArrayCollection();
			var locArraySize:int = locDataManager.originePlayerCharacterArray.length;
			
			DataManager.getInstance().playerCharacterArray = DataManager.getInstance().originePlayerCharacterArray;
			
			for (var session:int = 1; session <= parSessionNumber; session++){
				for (var i:int = 0; i < locArraySize; i++)
				{
					var locPlayerCharacter:PlayerCharacter = new PlayerCharacter();
					var locTmpPlayerCharacter:PlayerCharacter = locDataManager.playerCharacterArray[i] as PlayerCharacter;
					
					copyPlayerCharacter(locTmpPlayerCharacter, locPlayerCharacter);
					trace("DEBUG: BuildPCArrayFromSession: Copie du personnage " + locPlayerCharacter.firstName + " " + locPlayerCharacter.lastName + " associé à la session " + session);
					locPlayerCharacter.session = session;
					locPlayerCharacterArray.addItem(locPlayerCharacter);
				}
			}
			// Mise jour du tableau de personnages
			locDataManager.playerCharacterArray = locPlayerCharacterArray;
			// Mise à jour du nombre de sessions
			CastingManager.getInstance().sessionNumber = parSessionNumber;
			// Mise à jour du nombre d'étapes de traitements
			CastingManager.getInstance().nbTotalStep = locDataManager.playerCharacterArray.length + (locDataManager.playerCharacterArray.length / CastingManager.getInstance().sessionNumber);
			trace("DEBUG: BuildPCArrayFromSession: Enregistrement du nombre de sessions : " + parSessionNumber);
		}
		
		/** DOCUMENTATION:
		 * Fonction qui crée un tableau de personnages depuis le DataManager en fonction de la session
		 * affectée au personnage
		 * @since 2011/12/15
		 * @author Riyad YAKINE
		 * @param Int Le numéro de la session désiré
		 * @return ArrayCollection La copie du tableau de personnages associés à la session courante
		 * */
		public static function buildSessionPlayerCharacterArray(parSessionNumber:int):ArrayCollection
		{
			trace("DEBUG: buildSessionPlayerCharacterArray: Création du tableau de personnage pour la session " + parSessionNumber);
			var locDataManager:DataManager = DataManager.getInstance();
			var locPlayerCharacterArray:ArrayCollection = new ArrayCollection();
			
			for each (var locTmpPlayerCharacter:PlayerCharacter in locDataManager.playerCharacterArray){
				if (locTmpPlayerCharacter.session == parSessionNumber){
					var locPlayerCharacter:PlayerCharacter = new PlayerCharacter();
					
					copyPlayerCharacter(locTmpPlayerCharacter, locPlayerCharacter);
					trace("DEBUG: buildSessionPlayerCharacterArray: Copie du personnage [" + locPlayerCharacter.firstName + " " + locPlayerCharacter.lastName + "] associé à la session " + locPlayerCharacter.session);
					locPlayerCharacterArray.addItem(locPlayerCharacter);
				}
			}
			return locPlayerCharacterArray;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui copie un personnage
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @param PlayerCharacter Le personnage a copié
		 * @param PlayerCharacter Le personnage copié
		 * */
		public static function copyPlayerCharacter(srcPC:PlayerCharacter, destPC:PlayerCharacter):void
		{
			destPC.firstName = srcPC.firstName;
			destPC.lastName = srcPC.lastName;
			destPC.idName = srcPC.idName;
			destPC.session = srcPC.session;
			destPC.playWithoutArray = srcPC.playWithoutArray;
			destPC.playWithArray = srcPC.playWithArray;
			destPC.sex = srcPC.sex;
			destPC.skillArray = srcPC.skillArray;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui copie un joueur
		 * @since 2011/12/08
		 * @author Riyad YAKINE
		 * @param HumanPlayer Le joueur a copié
		 * @param HumanPlayer Le joueur copié
		 * */
		public static function copyHumanPlayer(srcHP:HumanPlayer, destHP:HumanPlayer):void
		{
			destHP.available = srcHP.available;
			destHP.firstName = srcHP.firstName;
			destHP.lastName = srcHP.lastName;
			destHP.idName = srcHP.idName;
			destHP.playWhitoutArray = srcHP.playWhitoutArray;
			destHP.playWithArray = srcHP.playWithArray;
			destHP.inOtherSessionArray = srcHP.inOtherSessionArray;
			destHP.inSameSessionArray = srcHP.inSameSessionArray;
			destHP.sex = srcHP.sex;
			destHP.skillArray = srcHP.skillArray;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui calcul le nombre de session réalisable en fonction
		 * du nombre de joueurs et personnage
		 * @since 2011/12/08
		 * @author Riyad YAKINE
		 * @return int Le nombre de session jouable
		 * */
		public static function computeSessionNumberMax():int
		{
			var locSessionNumberMax:int = 0;
			var locDataManager:DataManager = DataManager.getInstance();
			
			if ((locDataManager.humanPlayerArray != null) && (locDataManager.originePlayerCharacterArray != null))
			{
				if ((locDataManager.humanPlayerArray.length > 0) && (locDataManager.originePlayerCharacterArray.length > 0))
				{
					locSessionNumberMax = locDataManager.humanPlayerArray.length / locDataManager.originePlayerCharacterArray.length;
					trace("DEBUG: ComputeSessionNumberMax: " + locDataManager.humanPlayerArray.length + " joueurs / "
						+ locDataManager.originePlayerCharacterArray.length + " persos = " + locSessionNumberMax + " sessions possibles")
				}
			}
			return locSessionNumberMax;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui calcul le nombre de session réalisable en fonction
		 * du nombre de joueurs et personnage (facultatif ou non)
		 * @since 2012/07/23
		 * @author Mickael LEBON
		 * @return int Le nombre de session jouable
		 * */
		public static function computeSessionNumberMaxWithFacultatif():int
		{
			var locSessionNumberMax:int = 0;
			var locDataManager:DataManager = DataManager.getInstance();
			
			if ((locDataManager.humanPlayerArray != null) && (locDataManager.originePlayerCharacterArray != null))
			{
				var locNumbHuman:int = locDataManager.humanPlayerArray.length;
				var locNumbPerso:int = locDataManager.originePlayerCharacterArray.length;
				var locNumbFacultatifPerso:int = 0;
				
				for each (var iter:PlayerCharacter in locDataManager.originePlayerCharacterArray) 
				{
					if (iter.isFacultatif)
					{
						++locNumbFacultatifPerso;
					}
				}				
				
				if ((locNumbHuman > 0) && (locNumbPerso > 0))
				{
					// Si aucun personnage facultatif
					if (locNumbFacultatifPerso == 0)
					{
						locSessionNumberMax = locNumbHuman / locNumbPerso;
						
						trace("DEBUG: ComputeSessionNumberMax: " + locNumbHuman + " joueurs / "
							+ locNumbPerso + " persos = " + locSessionNumberMax + " sessions possibles")	
					}
					else
					{
						// Si il y a des personnage facultatif
						var tmpNumbUnusedPlayer:int = locNumbHuman;
						var tmpNumbCharacterFacultatifToKeep:int = 0;
						
						for (var i:int = 0; i < locNumbFacultatifPerso; ++i)
						{
							if (tmpNumbUnusedPlayer < locNumbHuman % (locNumbPerso - i))
							{
								tmpNumbUnusedPlayer = locNumbHuman % (locNumbPerso - i);
								tmpNumbCharacterFacultatifToKeep = i;
							}						
						}
						
						DataManager.getInstance().nbCharacterFacultatifToKeep = tmpNumbCharacterFacultatifToKeep;
						locSessionNumberMax = locNumbHuman / (locNumbPerso - tmpNumbCharacterFacultatifToKeep);	
					}					
				}
			}
			return locSessionNumberMax;
		}
		
		/** DOCUMENTATION:
		 * Fonction qui construit un tableau correspondant à la suite d'int
		 * de 1 au nombre spécifié
		 * @since 2011/12/08
		 * @author Riyad YAKINE
		 * @param int Le nombre d'int désiré
		 * @return ArrayCollection La tableau construit
		 * */
		public static function buildIntArray(parIntNumber:int):ArrayCollection
		{
			var locIntArray:ArrayCollection = new ArrayCollection();
			
			for (var i:int = 0; i < parIntNumber; i++){
				locIntArray.addItem(i+1);
			}
			return locIntArray;
		}
		
		/** DOCUMENTATION:
		 * Fonction générique qui trie un tableau multicolonnes par ordre numérique décroissant
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @param Array Le tableau multicolonnes
		 * @param String Le nom de la colonne sur laquelle le tableau sera trié
		 * */
		public static function simpleNumericDescendingSort(parComplexArray:ArrayCollection,
														   parFieldName:String):void
		{
			// Création du champs sur lequel trier le tableau ainsi que les propriété de tri
			var locSortField:SortField = new SortField();
			locSortField.name = parFieldName;
			locSortField.numeric = true;
			locSortField.descending = true;
			
			// Création de la fonction de trie prenant les propriétés définies précédemment
			var locSort:Sort = new Sort();
			locSort.fields = [locSortField];
			
			// Trie et mise à jour du tableau
			parComplexArray.sort = locSort;
			parComplexArray.refresh();
		}
		
		
		/** DOCUMENTATION:
		 * Fonction générique qui trie un tableau multicolonnes par ordre numérique croissant
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @param Array Le tableau multicolonnes
		 * @param String Le nom de la colonne sur laquelle le tableau sera trié
		 * */
		public static function simpleNumericAscendingSort(parComplexArray:ArrayCollection,
														  parFieldName:String):void
		{
			// Création du champs sur lequel trier le tableau ainsi que les propriété de tri
			var locSortField:SortField = new SortField();
			locSortField.name = parFieldName;
			locSortField.numeric = true;
			
			// Création de la fonction de trie prenant les propriétés définies précédemment
			var locSort:Sort = new Sort();
			locSort.fields = [locSortField];
			
			// Trie et mise à jour du tableau
			parComplexArray.sort = locSort;
			parComplexArray.refresh();
		}
		
		/** DOCUMENTATION
		 * Fonction qui indique si il reste des joueurs disponible dans le référentiel
		 * @since 2011/05/11
		 * @author Riyad YAKINE
		 * @return Boolean Vrai si il reste des joueurs disponible Faux sinon
		 * */
		public static function isStillAvailableHumanPlayer():Boolean
		{
			var locHumanPlayerArray:Array = DataManager.getInstance().humanPlayerArray.toArray();
			
			for each (var locHumanPlayer:HumanPlayer in locHumanPlayerArray)
			{
				if (locHumanPlayer.available == true)
					return true;
			}
			return false;
		}
		
		public static function makeAvailableAllHumanPlayer(parHumanPlayerArray:ArrayCollection):void
		{
			for each (var locHumanPlayer:HumanPlayer in parHumanPlayerArray)
			{
				locHumanPlayer.available = true;
			}
		}
		
	}
}