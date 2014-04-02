package Model.CastingManager
{
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	
	import Model.DataManager.DataManager;
	import Model.ErrorManager.ErrorManager;
	
	import mx.collections.ArrayCollection;

	public class CastingAssociationForbidden
	{
		// Instance du singleton du CastingAssociationManager
		private static var _instance:CastingAssociationForbidden;
		
		// Les associations manuelles réalisées par l'utilisateur a ne pas realiser
		public static var _castingBanListAssociationArray:ArrayCollection = new ArrayCollection();
		
		// Creator
		public function CastingAssociationForbidden()
		{
		}
		
		public static function getInstance():CastingAssociationForbidden
		{
			if(_instance == null)
				_instance = new CastingAssociationForbidden();
			
			return _instance;
		}
		
		public function createNewForbiddenAssociation(parPlayerCharacter:PlayerCharacter, parHumanPlayer:HumanPlayer):void
		{
			if ((parHumanPlayer == null) || (parPlayerCharacter == null))
			{
				return;
			}
			
			// Vérification que l'association n'existe pas déjà
			for each (var iter:CastingAssociation in _castingBanListAssociationArray) 
			{
				if (iter._humanPlayer.idName == parHumanPlayer.idName)
				{
					// On supprime l'association du tableau
					_castingBanListAssociationArray.removeItemAt(_castingBanListAssociationArray.getItemIndex(iter));
					
					// On supprime des variables du personnage
					for each (var iter2:String in parPlayerCharacter.wontPlayCharacter) 
					{
						if (iter2 == parHumanPlayer.idName)
						{
							parPlayerCharacter.wontPlayCharacter.removeItemAt(parPlayerCharacter.wontPlayCharacter.getItemIndex(iter2));
						}
					}
				}
			}

			// Construction de la nouvelle association
			var locCastingAssociation:CastingAssociation = new CastingAssociation(parPlayerCharacter, parHumanPlayer);
			locCastingAssociation._locked = true;
			
			// Ajout de la nouvelle association
			_castingBanListAssociationArray.addItem(locCastingAssociation);
			
			// Association joueur/personnage
			parHumanPlayer.notCharacterAssociate = parPlayerCharacter;
			parPlayerCharacter.wontPlayCharacter.addItem(parHumanPlayer.idName);
		}
		
		public function associationIsForbidden(parAssociation:CastingAssociation):Boolean
		{
			if (parAssociation == null)
			{
				return false;
			}
			
			for each (var iter:String in parAssociation._humanPlayer.notCharacterAssociateArray) 
			{
				if (iter == parAssociation._playerCharacter.idName)
				{
					return true;
				}
			}
			
			
//			for each (var iter:CastingAssociation in _castingBanListAssociationArray) 
//			{
//				if ((iter._playerCharacter.idName == parAssociation._playerCharacter.idName)
//					&& (iter._humanPlayer.idName == parAssociation._humanPlayer.idName))
//				{
//					return true;
//				}
//			}
			
			return false;
		}
		
		public function getAssociationFromIdNameHumanPlayer(parId:String):CastingAssociation
		{
			for each (var iter:CastingAssociation in _castingBanListAssociationArray)
			{
				if (iter._humanPlayer.idName == parId)
				{
					return iter;
				}
			}
			
			return null;
		}
		
		public function createImportForbiddenAssotiation():void
		{
			ErrorManager.getInstance().addImportErrorMessage("START Importation Forbidden Association");
			for each (var iter:PlayerCharacter in DataManager.getInstance().originePlayerCharacterArray) 
			{
				for each (var iter2:String in iter.wontPlayCharacter) 
				{
					for each (var iter3:HumanPlayer in DataManager.getInstance().humanPlayerArray) 
					{
						if (iter3.idName == iter2)
						{
							createNewForbiddenAssociation(iter, iter3);
						}
					}					
				}				
			}
			ErrorManager.getInstance().addImportErrorMessage("END Importation Forbidden Association");
		}
	}
}