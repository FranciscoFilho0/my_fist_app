class Candidate {
  String name;
  String document;
  String email;
  String course;
  int graduationYear;
  bool available;

  //constructor
  Candidate({
    required this.name,
    required this.document,
    required this.email,
    required this.course,
    required this.graduationYear,
    required this.available,
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
      ),

      Candidate(
        name: "Pedro silva",
        document: "123456789",
        email: "pedro.silva@example.com",
        course: "Tecnico em Informatica para Internet",
        graduationYear: 2026,
        available: false,
      ),

      Candidate(
        name: "Nayra Sousa",
        document: "12345678950",
        email: "nararodrygues530@gmail.com",
        course: "técnico Em informática para internet",
        graduationYear: 2026,
        available: true,
      ),

      Candidate(
        name: "Joao pedro",
        document: "01254125898",
        email: "joaopedro@gmail.com",
        course: "Tec. em inf para internet",
        graduationYear: 2026,
        available: true,
      ),

      Candidate(
        name: "Ezequiel Santos",
        document: "1234567890",
        email: "ezequiel25@gmail.com",
        course: "Técnico em Informática para Internet",
        graduationYear: 2026,
        available: true,
      ),

      Candidate(
        name: "Elcio Reis",
        document: "1234567890",
        email: "elciof739@gmail.com",
        course: "Técnico em Informática para internet",
        graduationYear: 2026,
        available: false,
      ),

      Candidate(
        name: "Náyla Gabrielle",
        document: "1234567890",
        email: "nayla.gabrielle@ma.senac.br",
        course: "Técnico em Informática para Internet",
        graduationYear: 2026,
        available: true,
      ),
    ];
  }
}
