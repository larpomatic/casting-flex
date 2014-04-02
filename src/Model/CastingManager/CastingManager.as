package Model.CastingManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package CastingManager
	 * Le package CastingManager contient l'ensemble des models
	 * interagissant avec l'CastingManager. C'est le CastingManager
	 * qui va effectuer les différents appels aux algos d'association
	 * du casting.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - CastingManager.as
	 * C'est ce fichier qui va faire le lien avec le tableau 
	 * d'association e l'IHM.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	
	import Model.AlgoManager.AlgoManager;
	import Model.AlgoManager.AlgoParam;
	import Model.DataManager.DataManager;
	import Model.ToolBox.CastingAlgoTools;
	
	import mx.collections.ArrayCollection;

	public class CastingManager
	{
		// Instance du singleton du CastingManager
		private static var _instance:CastingManager;
		
		// Liste des sessions
		[Bindable]
		public var sessionArray:ArrayCollection = new ArrayCollection();
		
		// Nombre de session
		public var sessionNumber:int = 0;
		// Nombre d'étapes de traitements
		public var nbTotalStep:int = 0;
		// Nombre d'étapes traitées
		public var nbStepCompleted:int = 0;
		// Le tableau de CAC
		private var arrayCAC:ArrayCollection = null; 
		
		
		public function CastingManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance du CastingManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton CastingManager 
		 */
		public static function getInstance():CastingManager
		{
			if(_instance == null)
				_instance = new CastingManager();
			
			return _instance;
		}
		
		/**
		 * Fonction qui remets à zero le tableau de session 
		 */
		public static function removeSession():void
		{
			CastingManager.getInstance().sessionArray.removeAll();
		}
		
		/**
		 * Fonction qui renvoit le tableau de CAC
		 * @param int index de la session en cour
		 * @return Array le tableau de CAC
		 * @author Mickael LEBON
		 * @since 2012/03/12
		 **/
		public function getArrayCAC(index:int):ArrayCollection
		{
			// Besoin de recalculer le CAC
			if (index == 1)
			{
				// Récupération de notre liste de personnages
				var locPCArray:ArrayCollection = CastingAlgoTools.buildSessionPlayerCharacterArray(index);
				// Création de nos variables de traitements
				// Tableau qui contiendra l'ensemble des CastingAssociationCalculator (CAC)
				// avec un CAC par personnage
				var locCACArray:ArrayCollection = new ArrayCollection();
				// Récupération du critère de sexe
				var locSexCriteria:Boolean = AlgoParam.getInstance().sexCriteria;
				// Le nombre actuel de personnage facultatif dans la session
				var nbFacultatifCharacterInSession:int = 0;
				
				// Construction de notre tableau de CAC
				for each (var locPlayerCharacter:PlayerCharacter in locPCArray)
				{
					// Création du CAC pour le personnage courant
					var locCACConstructor:CastingAssociationCalculator =
						new CastingAssociationCalculator(locPlayerCharacter);
					
					// Récupération de notre tableau d'association d'un personnage
					// à tous les joueurs
					var locCastingAssociationArray:ArrayCollection =
						locCACConstructor._castingAssociationArray;
					// Trie des castingAssociation du personnage par score d'interpréation
					// décroissant
					// Nos association de personnage/joueurs sont ainsi tiré par 
					// facilité d'association
					CastingAlgoTools.simpleNumericDescendingSort(locCastingAssociationArray,
						"_performanceScore");
					
					if (locPlayerCharacter.isFacultatif)
					{
						if (nbFacultatifCharacterInSession < DataManager.getInstance().nbCharacterFacultatifToKeep)
						{							
							// Ajout du CAC à notre tableau de CAC
							locCACArray.addItem(locCACConstructor);
							
							// Augmentation du nombre d'étapes de traitements effectués
							CastingManager.getInstance().nbStepCompleted++;
							AlgoManager.getInstance().updateAlgoProgressBar();
							
							nbFacultatifCharacterInSession++;
						}																								
					}
					else
					{
						// Ajout du CAC à notre tableau de CAC
						locCACArray.addItem(locCACConstructor);
						
						// Augmentation du nombre d'étapes de traitements effectués
						CastingManager.getInstance().nbStepCompleted++;
						AlgoManager.getInstance().updateAlgoProgressBar();
					}
				}
				
				arrayCAC = locCACArray;
			}
			
			return arrayCAC;
		}
		
		/**
		 * Fonction qui renvoit la liste des joueurs qu'un joueur peut ajouter en tant que playwith or playwithout
		 * @param HumanPlayer le joueur actuel
		 * @return Array la liste des joueurs potentiellement ajoutable
		 * @author LEBON Mickael
		 * @since 2012/03/25
		 **/
		public function getPotentialPlayersToPlayWithOrWithout(player:HumanPlayer):ArrayCollection
		{
			// La liste des amis potentiels
			var potentialFriends:ArrayCollection = new ArrayCollection();
			// La liste de tous les joueurs
			var playersInSession:ArrayCollection = DataManager.getInstance().humanPlayerArray;
			
			// Iteration sur la liste des personnes présent
			for each (var currentPlayer:HumanPlayer in playersInSession) 
			{				
				if ((currentPlayer != player)
					&& (player.playWithArray.getItemIndex(currentPlayer) == -1)
					&& (player.playWithMendatoryArray.getItemIndex(currentPlayer) == -1)
					&& (player.playWhitoutArray.getItemIndex(currentPlayer) == -1))
				{
					potentialFriends.addItem(currentPlayer);
				}
			}
			
			return potentialFriends;
		}
		
		/**
		 * Fonction qui renvoit la liste des joueurs qu'un joueur peut ajouter en tant que playwith or playwithout
		 * @param HumanPlayer le joueur actuel
		 * @return Array la liste des joueurs potentiellement ajoutable
		 * @author LEBON Mickael
		 * @since 2012/03/25
		 **/
		public function getPotentialCharactersToPlayWithOrWithout(character:PlayerCharacter):ArrayCollection
		{
			// La liste des amis potentiels
			var potentialFriends:ArrayCollection = new ArrayCollection();
			// La liste de tous les joueurs
			var playersInSession:ArrayCollection = DataManager.getInstance().playerCharacterArray;
			
			// Iteration sur la liste des personnes présent
			for each (var currentPlayer:PlayerCharacter in playersInSession) 
			{				
				if ((currentPlayer != character)
					&& (character.playWithArray.getItemIndex(currentPlayer) == -1)
					&& (character.playWithoutArray.getItemIndex(currentPlayer) == -1))
				{
					potentialFriends.addItem(currentPlayer);
				}
			}
			
			return potentialFriends;
		}
		
		/**
		 * Fonction qui renvoit la liste des joueurs qu'un joueur peut ajouter en tant que dans la meme session ou non
		 * @param HumanPlayer le joueur actuel
		 * @return Array la liste des joueurs potentiellement ajoutable
		 * @author LEBON Mickael
		 * @since 2012/04/06
		 **/
		public function getPotentialPlayersToPlayInSameSessionOrNot(player:HumanPlayer):ArrayCollection
		{
			// La liste des amis potentiels
			var potentialFriends:ArrayCollection = new ArrayCollection();
			// La liste de tous les joueurs
			var playersInSession:ArrayCollection = DataManager.getInstance().humanPlayerArray;
			
			// Iteration sur la liste des personnes présent
			for each (var currentPlayer:HumanPlayer in playersInSession) 
			{				
				if ((currentPlayer != player)
					&& (player.inSameSessionArray.getItemIndex(currentPlayer) == -1)
					&& (player.inOtherSessionArray.getItemIndex(currentPlayer) == -1))
				{
					potentialFriends.addItem(currentPlayer);
				}
			}
			
			return potentialFriends;
		}
		
		/**
		 * Fonction qui renvoit la liste des joueurs qu'un joueur ne peut potentiellement pas interpreter
		 * @param HumanPlayer le joueur actuel
		 * @return Array la liste des joueurs potentiellement non interpretable
		 * @author LEBON Mickael
		 * @since 2012/07/06
		 **/
		public function getPotentialPlayersToNotInterprete(player:HumanPlayer):ArrayCollection
		{
			// La liste des amis potentiels
			var potentialInterpretation:ArrayCollection = new ArrayCollection();
			// La liste de tous les personnages
			var rolesInSession:ArrayCollection = DataManager.getInstance().playerCharacterArray;
			
			// Iteration sur la liste des personnages présent
			for each (var currentRole:PlayerCharacter in rolesInSession) 
			{				
				if ((player.notCharacterAssociateArray != null)
					&& (player.notCharacterAssociateArray.getItemIndex(currentRole) == -1))
				{
					potentialInterpretation.addItem(currentRole);
				}
			}
			
			return potentialInterpretation;
		}
	}
}