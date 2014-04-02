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
	 * Riyad YAKINE - Skill.as
	 * Donnée de base qui sauvegarde les attributs d'un critère
	 * Ces attributs représentent ce que l'on nomme une
	 * capacité (Skill)
	 * Un skill est propre à la fois à un personnage et à
	 * un joueur 
	 *****************************************************/
	
	public class Skill
	{
	
		// Le nom du critère
		public var name:String = "";
		// La capacité du critère (chiffre entre 1 (Très faible) et 100 (Très forte))
		// Par défaut 50 (Moyen ou neutre)
		public var capacity:int = 50;
		// La ponderation du critère
		public var ponderation:int = 1; 
		
		public function Skill()
		{
		}
	}
}