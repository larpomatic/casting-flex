package Model.AlgoManager
{
	/**Description
	 * * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package AlgoManager
	 * Le package AlgoManager contient l'ensemble des models
	 * interagissant avec l'AlgoManager. C'est l'AlgoManager
	 * qui va appeler les différents appels aux algos d'association.
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - AlgoManager.as
	 * Seul fichier du package à être en public, c'est lui qui
	 * va chercher les différents appels au algos d'association.
	 *****************************************************/
	
	import DataObjects.PlayerCharacter;
	
	import Model.CastingManager.CastingAssociation;
	import Model.CastingManager.CastingAssociationCalculator;
	import Model.CastingManager.CastingAssociationForbidden;
	import Model.CastingManager.CastingAssociationManager;
	import Model.CastingManager.CastingAssociationMendatory;
	import Model.CastingManager.CastingManager;
	import Model.CastingManager.CastingSession;
	import Model.DataManager.DataManager;
	import Model.ToolBox.CastingAlgoTools;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ProgressBar;
	import mx.core.INavigatorContent;
	import mx.messaging.channels.PollingChannel;
	
	public class AlgoManager extends EventDispatcher
	{
		// Instance du singleton de l'AlgoManager
		private static var _instance:AlgoManager;
		
		// Equilibre de preponderance  entre les competences et le respect des demandes relationnelles
		// > 50 signifie preponderance du respect des demandes relationnelles
		// < 50 signifie preponderance des competences
		[Bindable]
		public var _eqBetweenCompetencyAndRelation:Number = 50
		
		public function AlgoManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance de l'AlgoManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton AlgoManager 
		 */
		public static function getInstance():AlgoManager
		{
			if(_instance == null)
				_instance = new AlgoManager();
			
			return _instance;
		}
		
		/** DOCUMENTATION
		 * Fonction qui lance le best mean algo
		 * @param int l'index de la session en cour
		 * @return void
		 * @author Mickael LEBON
		 * @since 2012/03/13
		 * */
		public function bestMeanAlgo(index:int):void
		{
			trace("*************************************************************");
			trace("**");
			trace("** DEBUG [BestMeanAlgo]:");
			trace("** CAC par _stdDev décroissant");
			trace("** CA par _avgDev croissant");
			trace("**");
			trace("*************************************************************");
			
			// Remise à zéro du casting si il s'agit du calcul pour la premiere session on remet à zéro le casting
			if (index == 1)
			{
				CastingAlgoTools.makeAvailableAllHumanPlayer(DataManager.getInstance().humanPlayerArray);
				CastingManager.removeSession();
				CastingManager.getInstance().nbStepCompleted = 0;
			}

			// Tableau qui contiendra l'ensemble des CastingAssociationCalculator (CAC)
			// avec un CAC par personnage
			var locCACArray:ArrayCollection = CastingManager.getInstance().getArrayCAC(index);
			
			// Trie de notre tableau de CAC par écart-type décroissant
			// Les personnages sont ainsi trié par complexité d'association
			// plus l'association est complexe, plus l'écart à la moyenne du
			// personnage est grande (les joueurs l'interprète avec des niveau
			// totalement différent)
			CastingAlgoTools.simpleNumericDescendingSort(locCACArray, "_stdDev");
			
			// On va maintenant choisir les associations qui iront dans la
			// session pour chaque personnage afin de créer les session
			// Notre tableau d'association qui représentera une session
			var locSessionCastingAssociationArray:ArrayCollection = new ArrayCollection();
			
			for each (var locCastingAssociationCalculator:CastingAssociationCalculator in locCACArray)
			{
				trace("Choix du joueur pour le personnage [" + locCastingAssociationCalculator._playerCharacter.idName + "] de sexe {" + locCastingAssociationCalculator._playerCharacter.sex + "} dont l'écart à la moyenne d'interprétation est de :" + locCastingAssociationCalculator._stdDev);
				// Notre variable pour parcourir le tableau d'association du personnage
				var i:int = 0;
				
				// Notre tableau d'association pour le personnage
				var locPCCastingAssociationArray:ArrayCollection = locCastingAssociationCalculator._castingAssociationArray; 
				
				// La taille du tableau d'association du personnage qui
				// nous servira de cas d'arret
				var locCastingAssociationArraySize:int = locPCCastingAssociationArray.length;
				var breakpoint:int = 0;
				
				// On parcours le tableau d'association trié
				while (i < locCastingAssociationArraySize)
				{
					// On récupère l'association courante
					var locCastingAssociation:CastingAssociation = locPCCastingAssociationArray[i];
					trace("Association avec le joueur [" + locCastingAssociation._humanPlayer.idName + "] de sexe {" + locCastingAssociation._humanPlayer.sex + "} dont le score d'interprétation est de :" + locCastingAssociation._performanceScore)
					
					// Verification qu'une association verrouiller n'existe pas
					var locManualCastinAssociation:CastingAssociation = CastingAssociationMendatory.getInstance().getAssociationFromIdNamePlayerCharactere(locCastingAssociation._playerCharacter.idName);

					
					if (locManualCastinAssociation != null)
					{
						if (breakpoint == 0)
						{
							locCastingAssociation = locManualCastinAssociation;
							breakpoint++;
							i--;
						}
						else
						{
							breakpoint = 0;
						}
					}
					
					// On vérifie que l'association est disponible
					if 	((CastingAlgoTools.isAssociationAvailable(locCastingAssociation))
						&& (CastingAssociationForbidden.getInstance().associationIsForbidden(locCastingAssociation) == false))
					{
						trace("Le joueur est disponible");
						
						// On  peut donc ajouter l'association à notre tableau d'association
						// qui correspondra à notre session
						locSessionCastingAssociationArray.addItem(locCastingAssociation);
						
						// On rends le joueur indisponible
						locCastingAssociation._humanPlayer.available = false;		
						
						trace("DEBUG [BestMeanAlgo]: L'association personnage/joueur: " + locCastingAssociation._playerCharacter.idName +
							" / " + locCastingAssociation._humanPlayer.idName + " a ete ajoute a la session avec un score de " + 
							locCastingAssociation._performanceScore);
						
						// On passe notre variable de parcours à une valeur
						// de cas d'arret
						
						i = locCastingAssociationArraySize;
					}
					else
					{
						trace("Le joueur n'est plus disponible -> Association suivante")
						
						// L'association n'est plus disponible donc on passe à la suivante
						i++;
					}
				}
				// Augmentation du nombre d'étapes de traitements effectués
				CastingManager.getInstance().nbStepCompleted++;
				updateAlgoProgressBar();
			}
			
			// On a parcouru tous les personnages et on va donc créer la session correspondante à l'index
			var locCastingSession:CastingSession = new CastingSession(locSessionCastingAssociationArray);
			
			// On ajoute la session au CastingManager afin de la rendre disponible dans la vue
			CastingManager.getInstance().sessionArray.addItem(locCastingSession);
			
			if (index < CastingManager.getInstance().sessionNumber)
			{
				setTimeout(AlgoManager.getInstance().bestMeanAlgo,1000,index + 1);
				trace("--------------------------------------------------------");
				trace("Fin de Best Mean pour la session : " + index);
				trace("Best Mean SESSION : " + index);
				trace("--------------------------------------------------------");
				return;
			}
			else
			{
				// L'algo est terminé donc on envoi un évènement de fin pour la progress bar
				dispatchEvent(new Event(Event.COMPLETE));
				trace("--------------------------------------------------------");
				trace("Fin de Best Mean pour la session : " + index);
				trace("Best Mean SESSION : " + index);
				trace("--------------------------------------------------------");
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui lance le maximum algo
		 * @param int index de la session
		 * @return void
		 * @author Mickael LEBON
		 * @since 2012/03/12
		 * */
		public function maximumAlgo(index:int):void
		{
			trace("*************************************************************");
			trace("**");
			trace("** DEBUG [MaxAlgo]:");
			trace("** CAC par _max décroissant");
			trace("** CA par _performanceScore croissant");
			trace("**");
			trace("*************************************************************");

			// Remise à zéro du casting si il s'agit du calcul pour la premiere session on remet à zéro le casting
			if (index == 1)
			{
				CastingAlgoTools.makeAvailableAllHumanPlayer(DataManager.getInstance().humanPlayerArray);
				CastingManager.removeSession();
				CastingManager.getInstance().nbStepCompleted = 0;
			}
			
			// Tableau qui contiendra l'ensemble des CastingAssociationCalculator (CAC)
			// avec un CAC par personnage
			var locCACArray:ArrayCollection = CastingManager.getInstance().getArrayCAC(index);
			
			// Trie de notre tableau de CAC par écart-type décroissant
			// Les personnages sont ainsi trié par complexité d'association
			// plus l'association est complexe, plus l'écart à la moyenne du
			// personnage est grande (les joueurs l'interprète avec des niveau
			// totalement différent)
			CastingAlgoTools.simpleNumericDescendingSort(locCACArray, "_max");
			
			// On va maintenant choisir les associations qui iront dans la
			// session pour chaque personnage afin de créer les session
			// Notre tableau d'association qui représentera une session
			var locSessionCastingAssociationArray:ArrayCollection = new ArrayCollection();
			
			for each (var locCastingAssociationCalculator:CastingAssociationCalculator in locCACArray)
			{
				// Notre variable pour parcourir le tableau d'association du personnage
				var i:int = 0;
				// Notre tableau d'association pour le personnage
				var locPCCastingAssociationArray:ArrayCollection = locCastingAssociationCalculator._castingAssociationArray;
				// La taille du tableau d'association du personnage qui
				// nous servira de cas d'arret
				var locCastingAssociationArraySize:int = locPCCastingAssociationArray.length;
				
				
				// On parcours le tableau d'association trié
				while (i < locCastingAssociationArraySize)
				{
					// On récupère l'association courante
					var locCastingAssociation:CastingAssociation = locPCCastingAssociationArray[i];
					
					// On vérifie que l'association est disponible
					if 	(CastingAlgoTools.isAssociationAvailable(locCastingAssociation))
					{
						// On  peut donc ajouter l'association à notre tableau d'association
						// qui correspondra à notre session
						locSessionCastingAssociationArray.addItem(locCastingAssociation);
						// On rends le joueur indisponible
						locCastingAssociation._humanPlayer.available = false;
						trace("DEBUG [MaxAlgo]: L'association personnage/joueur: " + locCastingAssociation._playerCharacter.idName +
							" / " + locCastingAssociation._humanPlayer.idName + " a ete ajoute a la session avec un score de " + 
							locCastingAssociation._performanceScore);
						// On passe notre variable de parcours à une valeur
						// de cas d'arret
						i = locCastingAssociationArraySize;
					} 
					else 
					{
						// L'association n'est plus disponible donc on
						// passe à la suivante
						i++;
					}
				}
			}
			
			// On a parcouru tous les personnages et on va donc créer la session
			var locCastingSession:CastingSession = new CastingSession(locSessionCastingAssociationArray);
			// On ajoute la session au CastingManager afin de la rendre disponible dans la vue
			CastingManager.getInstance().sessionArray.addItem(locCastingSession);
			
			if (index < CastingManager.getInstance().sessionNumber){
				setTimeout(AlgoManager.getInstance().maximumAlgo,1000,index + 1);
				trace("--------------------------------------------------------");
				trace("Fin de Maximum Algo pour la session : " + index);
				trace("Maximum Algo SESSION : " + index);
				trace("--------------------------------------------------------");
				return;
			}
			else
			{
				// L'algo est terminé donc on envoit un évènement de fin pour la progress bar
				dispatchEvent(new Event(Event.COMPLETE));
				trace("--------------------------------------------------------");
				trace("Fin de Maximum Algo pour la session : " + index);
				trace("Maximum Algo SESSION : " + index);
				trace("--------------------------------------------------------");
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui lance le firstfit algo
		 * @param int index de la session
		 * @return void
		 * @author Mickael LEBON
		 * @since 2012/03/13
		 * */
		public function firstFitAlgo(index:int):void
		{
			trace("*************************************************************");
			trace("**");
			trace("** DEBUG [FirstFitAlgo]:");
			trace("** CAC par ordre de traitement");
			trace("** CA par ordre de traitement");
			trace("**");
			trace("*************************************************************");

			
			// Remise à zéro du casting si il s'agit du calcul pour la premiere session on remet à zéro le casting
			if (index == 1)
			{
				CastingAlgoTools.makeAvailableAllHumanPlayer(DataManager.getInstance().humanPlayerArray);
				CastingManager.removeSession();
				CastingManager.getInstance().nbStepCompleted = 0;
			}
			
			// Tableau qui contiendra l'ensemble des CastingAssociationCalculator (CAC)
			// avec un CAC par personnage
			var locCACArray:ArrayCollection = CastingManager.getInstance().getArrayCAC(index);
			
			// On va maintenant choisir les associations qui iront dans la
			// session pour chaque personnage afin de créer les session
			// Notre tableau d'association qui représentera une session
			var locSessionCastingAssociationArray:ArrayCollection = new ArrayCollection();
			
			for each (var locCastingAssociationCalculator:CastingAssociationCalculator in locCACArray)
			{
				// Notre variable pour parcourir le tableau d'association du personnage
				var i:int = 0;
				// Notre tableau d'association pour le personnage
				var locPCCastingAssociationArray:ArrayCollection = locCastingAssociationCalculator._castingAssociationArray;
				// La taille du tableau d'association du personnage qui
				// nous servira de cas d'arret
				var locCastingAssociationArraySize:int = locPCCastingAssociationArray.length;
				
				
				// On parcours le tableau d'association trié
				while (i < locCastingAssociationArraySize)
				{
					// On récupère l'association courante
					var locCastingAssociation:CastingAssociation = locPCCastingAssociationArray[i];
					
					// On vérifie que l'association est disponible
					if 	(CastingAlgoTools.isAssociationAvailable(locCastingAssociation))
					{
						// On  peut donc ajouter l'association à notre tableau d'association
						// qui correspondra à notre session
						locSessionCastingAssociationArray.addItem(locCastingAssociation);
						// On rends le joueur indisponible
						locCastingAssociation._humanPlayer.available = false;
						trace("DEBUG [FirstFitAlgo]: L'association personnage/joueur: " + locCastingAssociation._playerCharacter.idName +
							" / " + locCastingAssociation._humanPlayer.idName + " a ete ajoute a la session avec un score de " + 
							locCastingAssociation._performanceScore);
						// On passe notre variable de parcours à une valeur
						// de cas d'arret
						i = locCastingAssociationArraySize;
					} 
					else 
					{
						// L'association n'est plus disponible donc on
						// passe à la suivante
						i++;
					}
				}
			}
			
			// On a parcouru tous les personnages et on va donc créer la session
			var locCastingSession:CastingSession = new CastingSession(locSessionCastingAssociationArray);
			// On ajoute la session au CastingManager afin de la rendre disponible dans la vue
			CastingManager.getInstance().sessionArray.addItem(locCastingSession);
			
			if (index < CastingManager.getInstance().sessionNumber){
				setTimeout(AlgoManager.getInstance().firstFitAlgo,1000,index + 1);
				trace("--------------------------------------------------------");
				trace("Fin de First Fit Algo pour la session : " + index);
				trace("First Fit Algo SESSION : " + index);
				trace("--------------------------------------------------------");
				return;
			}
			else
			{
				// L'algo est terminé donc on envoit un évènement de fin pour la progress bar
				dispatchEvent(new Event(Event.COMPLETE));
				trace("--------------------------------------------------------");
				trace("Fin de First Fit Algo pour la session : " + index);
				trace("First Fit Algo SESSION : " + index);
				trace("--------------------------------------------------------");
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui lance la progressBar
		 * @param void
		 * @return void
		 * @author Riyad YAKINE
		 * @since 2011/10/09
		 * */
		public function updateAlgoProgressBar():void
		{
			// Création de l'évènement de progression de l'algo
			var algoProgressionEvent:ProgressEvent;
			
			trace("Progression : " + CastingManager.getInstance().nbStepCompleted + " / " + CastingManager.getInstance().nbTotalStep);
			algoProgressionEvent = new ProgressEvent(ProgressEvent.PROGRESS,false,false,CastingManager.getInstance().nbStepCompleted, CastingManager.getInstance().nbTotalStep);
			algoProgressionEvent.bytesLoaded = CastingManager.getInstance().nbStepCompleted;
			algoProgressionEvent.bytesTotal = CastingManager.getInstance().nbTotalStep;
			dispatchEvent(algoProgressionEvent);
		}
	}
}