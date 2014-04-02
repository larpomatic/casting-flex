package DataObjects
{
	/**Description
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
	 * Riyad YAKINE - Entity.as
	 * Donnée de base qui sauvegarde les attributs communs
	 * à un personnage et à un joueur. Ces attributs communs
	 * représentent ce que l'on nomme une entité 
	 *****************************************************/
	
	import mx.collections.ArrayCollection;
	
	public class Entity
	{
		// le nom
		[Bindable]
		public var lastName:String = "";
		// le prénom
		[Bindable]
		public var firstName:String = "";
		// l'identifiant correspondant à la concaténation du prénom et du nom
		[Bindable]
		public var idName:String = "";
		// le sexe
		[Bindable]
		public var sex:String = "N";       
		// la liste de skills de l'entité
		[Bindable]
		public var skillArray:ArrayCollection = new ArrayCollection();
		// permet de savoir si l'on est en train de créer une nouvelle entité
		public var onCreateEntity:Boolean = false;
		
		public function Entity()
		{
		}
	}
}