package Model.CastingManager
{
	import Views.Renderers.SessionRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.errors.NoChannelAvailableError;
	import mx.preloaders.DownloadProgressBar;

	public class CastingAssociationResult
	{
		// Instance du singleton du CastingAssociationResult
		private static var _instance:CastingAssociationResult;
		
		public function CastingAssociationResult()
		{
		}
		
		/**
		 * Fonction qui retourne l'instance du singleton CastingAssociationResult 
		 */
		public static function getInstance():CastingAssociationResult
		{
			if(_instance == null)
				_instance = new CastingAssociationResult();
			
			return _instance;
		}
		
		public function getBestBoyAssociation():ArrayCollection
		{
			var bestBoy:ArrayCollection = new ArrayCollection;
			
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					// On vérifie que c'est bien un homme
					if (iter._humanPlayer.sex == 'M')
					{
						if (bestBoy.length == 7)
						{
							// Cas 7 hommes dans le tableau
							var score:int = 100;
							var index:int = 0;
							for (var j:int; j < bestBoy.length; ++j) 
							{
								if (bestBoy[j]._performanceScore < score)
								{
									index = j;
									score = bestBoy[j]._performanceScore;
								}
							}
							bestBoy.removeItemAt(index);
						}
						
						// Cas moins de 7 hommes dans le tableau
						bestBoy.addItem(iter);
					}
				}				
			}
			
			return bestBoy;
		}
		
		public function getBestGirlAssociation():ArrayCollection
		{
			var bestGirl:ArrayCollection = new ArrayCollection;
			
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					// On vérifie que c'est bien un homme
					if (iter._humanPlayer.sex == 'F')
					{
						if (bestGirl.length == 7)
						{
							// Cas 7 hommes dans le tableau
							var score:int = 100;
							var index:int = 0;
							for (var j:int; j < bestGirl.length; ++j) 
							{
								if (bestGirl[j]._performanceScore < score)
								{
									index = j;
									score = bestGirl[j]._performanceScore;
								}
							}
							bestGirl.removeItemAt(index);
						}
						
						// Cas moins de 7 hommes dans le tableau
						bestGirl.addItem(iter);
					}
				}				
			}			
			return bestGirl;
		}
		

		public function getWorstBoyAssociation():ArrayCollection
		{
			var worstBoy:ArrayCollection = new ArrayCollection;
			
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					// On vérifie que c'est bien un homme
					if (iter._humanPlayer.sex == 'M')
					{
						if (worstBoy.length == 7)
						{
							// Cas 7 hommes dans le tableau
							var score:int = 0;
							var index:int = 0;
							for (var j:int; j < worstBoy.length; ++j) 
							{
								if (worstBoy[j]._performanceScore > score)
								{
									index = j;
									score = worstBoy[j]._performanceScore;
								}
							}
							worstBoy.removeItemAt(index);
						}
						
						// Cas moins de 7 hommes dans le tableau
						worstBoy.addItem(iter);
					}
				}				
			}
			
			return worstBoy;
		}
		
		public function getWorstGirlAssociation():ArrayCollection
		{
			var worstGirl:ArrayCollection = new ArrayCollection;
			
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					// On vérifie que c'est bien un homme
					if (iter._humanPlayer.sex == 'F')
					{
						if (worstGirl.length == 7)
						{
							// Cas 7 hommes dans le tableau
							var score:int = 0;
							var index:int = 0;
							for (var j:int; j < worstGirl.length; ++j) 
							{
								if (worstGirl[j]._performanceScore > score)
								{
									index = j;
									score = worstGirl[j]._performanceScore;
								}
							}
							worstGirl.removeItemAt(index);
						}
						
						// Cas moins de 7 hommes dans le tableau
						worstGirl.addItem(iter);
					}
				}				
			}			
			return worstGirl;
		}
		
		public function getMoyenneScoreAssociation():Number
		{
			var score:Number = 0;
			var nbCharacter:Number = 0;
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					score += iter._performanceScore;
					nbCharacter++;
				}				
			}
			
			if (nbCharacter != 0)
			{
				score = score / nbCharacter; 
			}
			
			return score;
		}
		
		public function getMoyenneScoreBoyAssociation():Number
		{
			var score:Number = 0;
			var nbCharacter:Number = 0;
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					if (iter._humanPlayer.sex == 'M')
					{
						score += iter._performanceScore;
						nbCharacter++;
					}
				}				
			}
			
			if (nbCharacter != 0)
			{
				score = score / nbCharacter; 
			}
			
			return score;
		}
		
		public function getMoyenneScoreGirlAssociation():Number
		{
			var score:Number = 0;
			var nbCharacter:Number = 0;
			var locNbSession:int = CastingManager.getInstance().sessionArray.length;
			
			// On boucle sur toutes les sessions
			for (var i:int = 0; i < locNbSession; i++)
			{
				var currentSession:SessionRenderer = new SessionRenderer();
				
				currentSession.dataProvider = (CastingManager.getInstance().sessionArray.getItemAt(i) as CastingSession)._sessionCastingAssociationArray;
				for each (var iter:CastingAssociation in currentSession.dataProvider) 
				{
					if (iter._humanPlayer.sex == 'F')
					{
						score += iter._performanceScore;
						nbCharacter++;
					}
				}				
			}
			
			if (nbCharacter != 0)
			{
				score = score / nbCharacter; 
			}
			
			return score;
		}
	}
}