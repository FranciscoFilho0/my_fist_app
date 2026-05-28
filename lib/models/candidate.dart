class Candidate {
  String name;
  String document;
  String email;
  String course;
  int graduationYear;
  bool available;
  List<String> technicalSkills;
  List<String> softSkills;

  //constructor
  Candidate({
    required this.name,
    required this.document,
    required this.email,
    required this.course,
    required this.graduationYear,
    required this.available,
    required this.technicalSkills,
    required this.softSkills,
  });

  static List<Candidate> candidates() {
    return [
      Candidate(
        name: "Francisco Kassio",
        document: "123456789",
        email: "franciscokassio@example.com",
        course: "Tecnico em Informatica para Internet",
        graduationYear: 2026,
        available: true,
        technicalSkills: ["PHP", "HTML/CSS", "Flutter", "Dart"],
        softSkills: [
          "Comunicação",
          "Resolução de problemas",
          "Adaptação",
          "Liderança",
        ],
      ),

      Candidate(
        name: "Pedro silva",
        document: "123456789",
        email: "pedro.silva@example.com",
        course: "Tecnico em Informatica para Internet",
        graduationYear: 2026,
        available: false,
        technicalSkills: [
          "PHP",
          "JavaScript",
          "HTML",
          "CSS",
          "Flutter",
          "Dart",
        ],

        softSkills: [
          "Comunicação",
          "Trabalho em equipe",
          "Resolução de problemas",
          "Adaptabilidade",
        ],
      ),

      Candidate(
        name: "Nayra Sousa",
        document: "12345678950",
        email: "nararodrygues530@gmail.com",
        course: "técnico Em informática para internet",
        graduationYear: 2026,
        available: true,
        technicalSkills: [
          "HTML",
          "CSS",
          "Javascript",
          "PHP",
          "IA",
          "Informática básica",
          "Recepção",
        ],
        softSkills: ["impaciente", "agilidosa", "competente", "responsável"],
      ),

      Candidate(
        name: "Joao pedro",
        document: "01254125898",
        email: "joaopedro@gmail.com",
        course: "Tec. em inf para internet",
        graduationYear: 2026,
        available: true,
        technicalSkills: ["HTML", "CSS", "JavaScript", "Java", "PHP", "IA"],
        softSkills: [
          "Proativo",
          "Organização de tarefas",
          "Gestão do tempo",
          "Planejamento",
          "Criatividade",
        ],
      ),

      Candidate(
        name: "Ezequiel Santos",
        document: "1234567890",
        email: "ezequiel25@gmail.com",
        course: "Técnico em Informática para Internet",
        graduationYear: 2026,
        available: true,
        technicalSkills: [
          "HTML",
          "CSS",
          "Javascript",
          "Tecnico em Recursos Humanos", 
        ],
        softSkills: ["Criativo", "Empatia", "Paciente"]
      ),

      Candidate(
        name: "Elcio Reis",
        document: "1234567890",
        email: "elciof739@gmail.com",
        course: "Técnico em Informática para internet",
        graduationYear: 2026,
        available: false,
        technicalSkills: [
          "HTML",
          "TAILWINDCSS",
          "JAVASCRIPT",
          "TYPESCRIPT",
          "PHP",
          "REACT",
          "NEXT.JS",
          "NODE.JS",
          "MYSQL",
          "MONGODB",
          "DEPLOY",
          "ASSISTENTE ADMINISTRATIVO",
          "DESIGNER GRÁFICO",
        ],

        softSkills: [
          "Foco em resultados",
          "Proativo",
          "Facilidade em aprender",
          "Pensamento crítico",
          "Busca por inovação",
        ],
      ),

      Candidate(
        name: "Náyla Gabrielle",
        document: "1234567890",
        email: "nayla.gabrielle@ma.senac.br",
        course: "Técnico em Informática para Internet",
        graduationYear: 2026,
        available: true,
        technicalSkills: ["HTML", "CSS", "JAVASCRIPT", "PHP"],
        softSkills: ["Pensamento Crítico", "Adaptabilidade", "Empatia"],
      ),
    ];
  }
}
