package DataObjects
{
	/**DESCRIPTION
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - package DataObject
	 * Le package DataObject contient l'ensemble des données
	 * nécessaire à l'application. Une classe appartenant à
	 * ce package est assimilé à une table d'une BDD et ne
	 * contient que des attributs qui sont équivalent aux
	 * attributs de la table d'une BDD. Aucune méthode n'est
	 * implémenté dans ces classes et seuls les classes du
	 * package model interagissent avec les DataObjects
	 *----------------------------------------------------
	 * 2011-04-09 : PRC FédéGN / SIGL 2012 
	 * Riyad YAKINE - HumanPlayer.as
	 * Donnée de base qui sauvegarde les attributs propre
	 * à un joueur. Ces attributs représentent ce que l'on
	 * nomme un joueur humain (HumanPlayer ou HP)
	 * Il s'agit d'une classe héritant de Entity 
	 *****************************************************/
	
	import mx.collections.ArrayCollection;

	public class HumanPlayer extends Entity
	{
		// La liste des HP de la même session avec qui il veut partager des scènes
		[Bindable]
		public var playWithArray:ArrayCollection = new ArrayCollection();
		// La liste des HP de la même session avec qui il veut OBLIGATOIREMENT partager des scènes
		[Bindable]
		public var playWithMendatoryArray:ArrayCollection = new ArrayCollection();
		// La liste des HP de la même session avec qui il ne veut pas partager de scènes
		[Bindable]
		public var playWhitoutArray:ArrayCollection = new ArrayCollection();
		// La liste des HP avec qui il veut jouer dans la même session
		[Bindable]
		public var inSameSessionArray:ArrayCollection = new ArrayCollection();
		// La liste des HP avec qui il ne veut pas jouer dans la même session
		[Bindable]
		public var inOtherSessionArray:ArrayCollection = new ArrayCollection();
		// La disponibilité du joueur pour l'affectation du casting
		public var available:Boolean = true;
		// Le personnage auquel il est associé
		[Bindable]
		public var characterAssociate:PlayerCharacter = null;
		// Le personnage auquel il n'est pas associé
		[Bindable]
		public var notCharacterAssociate:PlayerCharacter = null;
		[Bindable]
		public var notCharacterAssociateArray:ArrayCollection = new ArrayCollection();
		// Le joueur est associé manuellement
		[Bindable]
		public var manualAssociation:Boolean = false;
		
		public function HumanPlayer()
		{
			super();
		}
	}
}