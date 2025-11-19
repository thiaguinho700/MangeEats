import 'package:flutter/material.dart';

class Cadastro_page extends StatefulWidget {
  const Cadastro_page({super.key});

  @override
  State<Cadastro_page> createState() => _Cadastro_pageState();
}

class _Cadastro_pageState extends State<Cadastro_page> {
  bool checkBox = false;
  bool hidePassword = true;

  Icon eyeOpenPassword = Icon(Icons.visibility, color: Colors.black);
  Icon eyeClosePassword = Icon(Icons.visibility_off, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      body: Center(
        child: Container(
          width: 380,
          height: 800,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bem-Vindo",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    label: Text("Nome"),
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
              TextFormField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  label: Text("Senha"),
                  icon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    isSelected: checkBox,
                    onPressed: () => setState(() {
                      hidePassword = !hidePassword;
                    }),
                    icon: hidePassword ? eyeClosePassword : eyeOpenPassword,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    label: Text("Senha novamente"),
                    icon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      isSelected: checkBox,
                      onPressed: () => setState(() {
                        hidePassword = !hidePassword;
                      }),
                      icon: hidePassword ? eyeClosePassword : eyeOpenPassword,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkBox,
                    onChanged: (bool? value) => {setState(() {
                      checkBox = value!;
                    })},
                    activeColor: Colors.red[400],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text("Aceite nossos termos e contratos"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: EdgeInsets.only(
                    right: 100,
                    left: 100,
                    bottom: 13,
                    top: 13,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Já possui uma conta? "),
                  Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.red[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
