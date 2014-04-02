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
	 * Riyad YAKINE - PlayerCharacter.as
	 * Donnée de base qui sauvegarde les attributs propre
	 * à un personnage. Ces attributs représentent ce que l'on
	 * nomme un personnage jouable (PlayerCharacter ou PC)
	 * Il s'agit d'une classe héritant de Entity 
	 *****************************************************/
	
	import mx.collections.ArrayCollection;
	
	public class PlayerCharacter extends Entity
	{
		// La liste des PC avec qui il partage des scènes
		[Bindable]
		public var playWithArray:ArrayCollection = new ArrayCollection();
		
		// La liste des PC avec qui il ne partage pas des scènes
		[Bindable]
		public var playWithoutArray:ArrayCollection = new ArrayCollection();
		
		// La liste des joueurs qui doivent jouer ce personnage
		[Bindable]
		public var wannaPlayCharacter:ArrayCollection = new ArrayCollection();
		
		// La liste des joueurs qui ne doivent pas jouer ce personnage
		[Bindable]
		public var wontPlayCharacter:ArrayCollection = new ArrayCollection();
		
		// Variable indiquant si un personnage est facultatif ou non
		[Bindable]
		public var isFacultatif:Boolean = false;
		
		// La session attribué
		public var session:int;
		
		public function PlayerCharacter()
		{
			super();
		}
	}
}