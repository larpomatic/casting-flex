package Model.ToolBox
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	public class ExportGenotron
	{
		public static var _instance:ExportGenotron = null;
		
		public function ExportGenotron()
		{			
		}
		
		public static function getInstance():ExportGenotron
		{
			if (_instance == null)
			{
				_instance = new ExportGenotron();
			}
			
			return _instance;
		}
		
		public function Export():void
		{
			var fileReference:FileReference = new FileReference();
			var text:ByteArray = new ByteArray();
			text.writeMultiByte(buildExport(), "latin9");
			fileReference.save(text, "GNK-Export_Génotron.html");
		}
		
		private function buildExport():String
		{
			var htmlContent:String = new String();

			// Construction du Titre
			htmlContent += buildTitle();
			htmlContent += buildOrganiserSynthesis();
			htmlContent += buildEventDetails();
			htmlContent += buildLogisticDetails();
			htmlContent += buildStorieAndCaracteres();
			htmlContent += buildCaractereFiles();
			
			// Construction du Synthèses pour l'Organisateur
			
			return htmlContent;
		}
		
		private function buildTitle():String
		{
			// Création du titre
			var title:String = "<H1 ALIGN=CENTER> GNK - ";
			
			// Récupération du titre
			
			// Fin du titre
			title += "</H1>\n";
			
			return title;
		}
		
		private function buildOrganiserSynthesis():String
		{
			// Création du titre
			var result:String = "<H2 ALIGN=JUSTIFY> Synthèses pour l'Organisateur </H2>\n";
			
			result += buildCaracteresSynthesis();
			result += buildStorieSynthesis();
			result += buildEventSynthesis();
			result += buildLocationSynthesis();
			result += buildLogisticSynthesis();
			
			return result;
		}
		
		private function buildCaracteresSynthesis():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY> Synthèse des personnages du GN </H3>\n";
			
			// Début tableau
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Nom personnage</td><td>Nb PIP</td><td>Type</td><td>Sexe</td><td>Description</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>";
			
			return result;
		}
		
		private function buildStorieSynthesis():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY> Synthèse des Intrigues du GN </H3>\n";
			
			// Début tableau
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Nom Intrigue</td><td>Nb PIP total</td><td>Liste des Tags associés</td><td>Résumé / Description</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>\n";
			
			return result;			
		}
		
		private function buildEventSynthesis():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY> Synthèse de l'Événementiel  du GN </H3>\n";
			
			// Début tableau
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Timing evenementiel</td><td>Titre event</td><td>Lieu</td><td>Intrigue concernée</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>\n";
			
			return result;			
		}
		
		private function buildLocationSynthesis():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY> Synthèse des Lieux du GN </H3>\n";
			
			// Début tableau
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Catégorie</td><td>Type</td><td>Nom lieu</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>\n";
			
			return result;			
		}
		
		private function buildLogisticSynthesis():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY> Synthèse Logistique du GN </H3>\n";
			
			// Début tableau
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Catégorie</td><td>Type</td><td>Nom ressource</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>\n";
			
			return result;			
		}
		
		private function buildEventDetails():String
		{
			// Création du titre
			var result:String = "<H2 ALIGN=JUSTIFY> Événementiel Détaillé </H2>\n";
			
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Date evenementiel</td><td>Titre event</td><td>Intrigue concernée</td><td>Lieu</td><td>Description</td>"
				+ "<td>Logistiques</td><td>Type Perso présents</td><td>Perso présent</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>";
			
			return result;
		}
		
		private function buildLogisticDetails():String
		{
			// Création du titre
			var result:String = "<H2 ALIGN=JUSTIFY> Logistique détaillée </H2>\n";
			
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Catégorie</td><td>Type</td><td>Nom</td><td>Intrigues l'utilisant</td><td>Quantité</td>"
				+ "<td>Emplacement début de jeu</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>";
			
			return result;
		}
		
		private function buildStorieAndCaracteres():String
		{
			// Création du titre
			var result:String = "<H2 ALIGN=JUSTIFY> Implications Personnages par intrigue </H2>\n";
			
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Intrigue</td><td>Personnage impliqué</td><td>Code rôle</td><td>Nb Pip</td><td>Description du rôle</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>";
			
			return result;
		}
		
		private function buildCaractereFiles():String
		{
			// Création du titre
			var result:String = "<H2 ALIGN=JUSTIFY> Dossiers Personnages </H2>\n";
			
			return result;
		}
		
		private function buildCaractereFile():String
		{
			// Création du titre
			var result:String = "<H3 ALIGN=JUSTIFY>";
			result += "</H3>";
			
			result += "<table border=\"3\">";
			
			// Titre tableau
			result += "<thead><tr><td>Timing past_scene_role</td><td>Titre past_scene_role</td><td>Intrigue concernée</td></tr></thead>";
			
			// Contenu du tableau
			result += "<tbody>";
			result += "</tbody>";
			
			// Fin tableau
			result += "</table>";
			
			return result;			
		}
	}
}