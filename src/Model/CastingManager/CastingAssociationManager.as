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
	 * Riyad YAKINE - CastingAssociationManager.as
	 * C'est ce fichier qui va contenir les elements necessaires
	 * a l'association.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	
	import flash.net.LocalConnection;
	
	import mx.collections.ArrayCollection;
	
	public class CastingAssociationManager
	{
		// Instance du singleton du CastingAssociationManager
		private static var _instance:CastingAssociationManager;
		
		// Les associations manuelles réalisées par l'utilisateur
		public static var _castingManualAssociationArray:ArrayCollection = new ArrayCollection();
		
		public function CastingAssociationManager()
		{
			if(_instance != null)
				trace("Il ne peut exister qu'une seule instance de CastingAssociationManager");
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton CastingAssociationManager 
		 */
		public static function getInstance():CastingAssociationManager
		{
			if(_instance == null)
				_instance = new CastingAssociationManager();
			
			return _instance;
		}
		
		/** DOCUMENTATION
		 * Fonction qui indique si un personnage est associé manuellement
		 * @param PlayerCharacter Le personnage recherché
		 * @Return Boolean Vrai si le personnage recherché est associé manuellement, Faux sinon
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 */
		public static function isPlayerCharacterAssociated(parPlayerCharacter:PlayerCharacter):Boolean
		{
			var locArraySize:int = _castingManualAssociationArray.length;
			
			if (locArraySize == 0)
				return false;
			else {
				for (var i:int = 0; i < locArraySize; i++){
					if ((_castingManualAssociationArray[i] as CastingAssociation)._playerCharacter.idName == parPlayerCharacter.idName)
						return true;
				}
				return false;
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui indique si un joueur est associé manuellement
		 * @param HumanPlayer Le joueur recherché
		 * @Return Boolean Vrai si le joueur recherché est associé manuellement, Faux sinon
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 */
		public static function isHumanPlayerAssociated(parHumanPlayer:HumanPlayer):Boolean
		{
			var locArraySize:int = _castingManualAssociationArray.length;
			
			if (locArraySize == 0)
				return false;
			else {
				for (var i:int = 0; i < locArraySize; i++){
					if ((_castingManualAssociationArray[i] as CastingAssociation)._humanPlayer.idName == parHumanPlayer.idName)
						return true;
				}
				return false;
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui supprime l'association d'un joueur du tableau d'association manuelle
		 * si celle ci n'est pas verrouillé
		 * @param HumanPlayer Le joueur dont l'association est recherché
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 */
		public static function removeExistingCastingAssociation(parHumanPlayer:HumanPlayer):Boolean
		{
			var locArraySize:int = _castingManualAssociationArray.length;
			
			if (locArraySize != 0){
				for (var i:int = 0; i < locArraySize; i++){
					if (((_castingManualAssociationArray[i] as CastingAssociation)._humanPlayer.idName == parHumanPlayer.idName)
						&& ((_castingManualAssociationArray[i] as CastingAssociation)._locked == false)){ 
						_castingManualAssociationArray.removeItemAt(i);
						parHumanPlayer.available = true;
						return true;
					}
				}
			}
			return false;
		}
		
		/** DOCUMENTATION
		 * Fonction qui supprime toutes les associations manuelles qui ne sont pas verrouillée
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 */
		public static function removeUnlockedCastingAssociation():void
		{
			var locArraySize:int = _castingManualAssociationArray.length;
			
			if (locArraySize != 0){
				for (var i:int = 0; i < locArraySize; i++){
					if (!(_castingManualAssociationArray[i] as CastingAssociation)._locked){
						(_castingManualAssociationArray[i] as CastingAssociation)._humanPlayer.available == true;
						_castingManualAssociationArray.removeItemAt(i);
					} 
				}
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui supprime toutes les associations manuelles
		 * @author Riyad YAKINE
		 * @since 2011/11/09
		 */
		public static function removeCastingAssociation():void
		{
			var locArraySize:int = _castingManualAssociationArray.length;
			
			if (locArraySize != 0){
				for (var i:int = 0; i < locArraySize; i++){
					(_castingManualAssociationArray[i] as CastingAssociation)._humanPlayer.available == true;
					_castingManualAssociationArray.removeItemAt(i);
				} 
			}
		}
		
		/** DOCUMENTATION
		 * Fonction qui créer une asoociation personnage/joueur effectué manuellement par l'utilisateur
		 * @param PlayerCharacter Le personnage à associer
		 * @param HumanPlayer Le joueur à associer
		 * @param Boolean Vrai si l'association est verrouillée, Faux sinon
		 * @author Mickael LEBON
		 * @since 2012/03/20
		 */
  		public static function createManualCastingAssociation(parPlayerCharacter:PlayerCharacter,
															  parHumanPlayer:HumanPlayer,
															  parLocked:Boolean):void
		{
			var locCastingAssociation:CastingAssociation = null;
			if (isPlayerCharacterAssociated(parPlayerCharacter))
				trace("DEBUG [CAM]: Le personnage " + parPlayerCharacter.idName + " est déjà associé manuellement");
			else{
				if (isHumanPlayerAssociated(parHumanPlayer)){
					if(removeExistingCastingAssociation(parHumanPlayer)){
						locCastingAssociation = new CastingAssociation(parPlayerCharacter, parHumanPlayer);
						locCastingAssociation._locked = parLocked;
						_castingManualAssociationArray.addItem(locCastingAssociation);
						trace("DEBUG [CAM]: L'association personnage/joueur: " + parPlayerCharacter.idName + " / "
							+ parHumanPlayer.idName + " de score " + locCastingAssociation._performanceScore + " est ajouté manuellement"
							+ "\n" + "Une association du joueur non verrouillé à été écraser pour cette opération");
					}else{
						trace("DEBUG [CAM]: L'association personnage/joueur: " + parPlayerCharacter.idName + " / "
							+ parHumanPlayer.idName + " est impossible car le joueur est déjà verrouillé dans une association manuelle");
					}
				}else{
					locCastingAssociation = new CastingAssociation(parPlayerCharacter, parHumanPlayer);
					locCastingAssociation._locked = parLocked;
					_castingManualAssociationArray.addItem(locCastingAssociation);
					trace("DEBUG [CAM]: L'association personnage/joueur: " + parPlayerCharacter.idName + " / "
						+ parHumanPlayer.idName + " de score " + locCastingAssociation._performanceScore + " est ajouté manuellement");
				}
			}
			// Association joueur/personnage
			parHumanPlayer.characterAssociate = parPlayerCharacter;
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		public static function getAssociationFromIdName(parId:String):CastingAssociation
		{	
			for each (var iter:CastingAssociation in CastingAssociationManager._castingManualAssociationArray) 
			{
				if (iter._playerCharacter.idName == parId)
				{
					// On recupère le resultat
					var result:CastingAssociation = iter;
					// On recupere l'index
					var index:int = CastingAssociationManager._castingManualAssociationArray.getItemIndex(iter);
					// On supprime l'association du tableau
					CastingAssociationManager._castingManualAssociationArray.removeItemAt(index);
					return iter;
				}
			}
			
			return null;
		}
	}
}
