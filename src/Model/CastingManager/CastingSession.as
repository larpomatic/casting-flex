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
	 * Riyad YAKINE - CastingSession.as
	 * C'est ce fichier gerer les actions se déroulant pendant une session.
	 *****************************************************/
	
	import DataObjects.HumanPlayer;
	import DataObjects.PlayerCharacter;
	import DataObjects.Skill;
	import Model.DataManager.DataManager;
	import Model.ToolBox.CastingAlgoTools;
	import Model.ToolBox.MathTools;
	
	import mx.collections.ArrayCollection;
	
	
	public class CastingSession
	{
		// La liste des associations personnage/joueur
		public var _sessionCastingAssociationArray:ArrayCollection = new ArrayCollection;
		// La moyenne d'interprétation de la session
		public var _sessionMeanPerfomanceScore:Number = 0.0;
		// La moyenne des écart-type de la session
		public var _sessionMeanPerformanceScoreStdDev:Number = 0.0;
		
		public function CastingSession(parCastingAssociationArray:ArrayCollection)
		{
			var locCastingAssociationArray:ArrayCollection = parCastingAssociationArray;
			_sessionCastingAssociationArray = locCastingAssociationArray;
			computeSessionScore(this);
		}
		
		/** DOCUMENTATION
		 * Fonction qui calcule la moyenne d'interprétation d'une session et son écart-type
		 * @since 2011/10/09
		 * @author Riyad YAKINE
		 */
		public function computeSessionScore(parCastingSession:CastingSession):void
		{
			var locSessionScoreArray:ArrayCollection = new ArrayCollection();
			var locSessionCastingAssociationArray:ArrayCollection = parCastingSession._sessionCastingAssociationArray;
			
			for each (var locCastingAssociation:CastingAssociation in locSessionCastingAssociationArray)
			{
				locSessionScoreArray.addItem(locCastingAssociation._performanceScore);	
			}
			
			parCastingSession._sessionMeanPerfomanceScore= MathTools.mean(locSessionScoreArray);
			parCastingSession._sessionMeanPerformanceScoreStdDev = MathTools.stdDev(locSessionScoreArray);
		}
		
	}
}