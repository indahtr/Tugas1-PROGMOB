import 'package:flutter/material.dart';
import 'home_page.dart'; 
import 'register_page.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    final dio = Dio();
    final _storage = GetStorage();

    try {
      final response = await dio.post('https://mobileapis.manpits.xyz/api/login', data: {
        'email': emailController.text,
        'password': passwordController.text
      });
      print(response.data);
      _storage.write('token', response.data['data']['token']);


      // Jika login berhasil, arahkan ke halaman beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on DioError catch (e) {
      print('Error : ${e.response?.statusCode} - ${e.response?.data}');
      // Tampilkan pesan kesalahan jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login failed. Please check your credentials.'),
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo, 
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white), 
                ),
                SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 16, color: Colors.white), 
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text('Remember me', style: TextStyle(color: Colors.white)), 
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Lupa password
                      },
                      child: Text('Forgot password?', style: TextStyle(color: Colors.white)), 
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    login(context); // Perbarui agar dapat meneruskan context
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
