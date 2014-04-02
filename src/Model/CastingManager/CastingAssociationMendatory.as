package Model.CastingManager
{
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	
	import Model.DataManager.DataManager;
	import Model.ErrorManager.ErrorManager;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

	public class CastingAssociationMendatory
	{
		// Instance du singleton du CastingAssociationManager
		private static var _instance:CastingAssociationMendatory;
		
		// Les associations manuelles réalisées par l'utilisateur a realiser
		public static var _castingMendatoryListAssociationArray:ArrayCollection = null;
		
		// Creator
		public function CastingAssociationMendatory()
		{
			_castingMendatoryListAssociationArray = new ArrayCollection();
			_castingMendatoryListAssociationArray.removeAll();
			
//			_castingMendatoryListAssociationArray.addEventListener(CollectionEvent.COLLECTION_CHANGE, resetCastingMendatory);
		}
		
		public static function getInstance():CastingAssociationMendatory
		{
			if(_instance == null)
				_instance = new CastingAssociationMendatory();
			
			return _instance;
		}
		
		public function createNewMendatoryAssociation(parPlayerCharacter:PlayerCharacter, parHumanPlayer:HumanPlayer):void
		{
			if ((parHumanPlayer == null) || (parPlayerCharacter == null))
			{
				return;
			}
			
			// Vérification que l'association n'existe pas déjà
			for each (var iter:CastingAssociation in _castingMendatoryListAssociationArray) 
			{
				if (iter._humanPlayer.idName == parHumanPlayer.idName)
				{
					// On supprime l'association du tableau
					_castingMendatoryListAssociationArray.removeItemAt(_castingMendatoryListAssociationArray.getItemIndex(iter));
					
					// On supprime des variables du personnage
					for each (var iter2:String in parPlayerCharacter.wannaPlayCharacter) 
					{
						if (iter2 == parHumanPlayer.idName)
						{
							parPlayerCharacter.wannaPlayCharacter.removeItemAt(parPlayerCharacter.wannaPlayCharacter.getItemIndex(iter2));
						}
					}
				}								
			}
			
			// Construction de la nouvelle association
			var locCastingAssociation:CastingAssociation = new CastingAssociation(parPlayerCharacter, parHumanPlayer);
			locCastingAssociation._locked = true;
			
			// Ajout de la nouvelle association
			_castingMendatoryListAssociationArray.addItem(locCastingAssociation);
			
			// Association joueur/personnage
			parHumanPlayer.characterAssociate = parPlayerCharacter;
			parPlayerCharacter.wannaPlayCharacter.addItem(parHumanPlayer.idName);
		}
		
		public function associationIsMendatory(parAssociation:CastingAssociation):Boolean
		{
			if (parAssociation == null)
			{
				return false;
			}
			
			for each (var iter:CastingAssociation in _castingMendatoryListAssociationArray) 
			{
				if ((iter._playerCharacter.idName == parAssociation._playerCharacter.idName)
					&& (iter._humanPlayer.idName == parAssociation._humanPlayer.idName))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getAssociationFromIdNamePlayerCharactere(parId:String):CastingAssociation
		{
			for each (var iter:CastingAssociation in _castingMendatoryListAssociationArray) 
			{
				if (iter._playerCharacter.idName == parId)
				{					
					return iter;
				}
			}
			
			return null;
		}
		
		public function getAssociationFromIdNameHumanPlayer(parId:String):CastingAssociation
		{
			for each (var iter:CastingAssociation in _castingMendatoryListAssociationArray)
			{
				if (iter._humanPlayer.idName == parId)
				{
					return iter;
				}
			}
			
			return null;
		}		
		
		public function createImportMendatoryAssotiation():void
		{
			ErrorManager.getInstance().addImportErrorMessage("START Importation Mendatory Association");
			// On parcour le tableau des personnages qui ont été importé		
			for each (var iter:PlayerCharacter in DataManager.getInstance().originePlayerCharacterArray) 
			{
				// Pour chaque personnage, on parcour la liste des joueurs qui doivent interpreter ce personnqge
				for each (var iter2:String in iter.wannaPlayCharacter) 
				{
					// On parcour le tableau des joueurs qui ont été importé
					for each (var iter3:HumanPlayer in DataManager.getInstance().humanPlayerArray) 
					{
						// Si le joueur correspond au joueur actuel associé au personnage, on crée l'association
						if (iter3.idName == iter2)
						{
							createNewMendatoryAssociation(iter, iter3);
						}
					}					
				}				
			}
			ErrorManager.getInstance().addImportErrorMessage("END Importation Mendatory Association");
		}
		
//		private function unicityMendatoryListElement():void
//		{
//			for (var i = 0; i <  _castingMendatoryListAssociationArray.length; ++i)
//			
//			for each (var iter:CastingAssociation in _castingMendatoryListAssociationArray) 
//			{
//				if (iter._humanPlayer.idName == parHumanPlayer.idName)
//				{
//					// On supprime l'association du tableau
//					_castingMendatoryListAssociationArray.removeItemAt(_castingMendatoryListAssociationArray.getItemIndex(iter));
//					
//					// On supprime des variables du personnage
//					for each (var iter2:String in parPlayerCharacter.wannaPlayCharacter) 
//					{
//						if (iter2 == parHumanPlayer.idName)
//						{
//							parPlayerCharacter.wannaPlayCharacter.removeItemAt(parPlayerCharacter.wannaPlayCharacter.getItemIndex(parHumanPlayer.idName));
//						}
//					}
//				}								
//			}
//		}
	}
}