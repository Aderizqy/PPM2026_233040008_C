import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Ditambahkan untuk fungsi kIsWeb
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

// Model data untuk menampung data Pengalaman
class Experience {
  final String imagePath;
  final String title;
  final String description;
  Experience({required this.imagePath, required this.title, required this.description});
}

// ==========================================
// HALAMAN UTAMA: PROFILE PAGE (STATEFUL)
// ==========================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State Data Profil Utama
  String name = 'Ade Rizqy Maulana';
  String about = 'Saya suka belajar hal baru, terutama teknologi mobile.';
  String education = 'Universitas Pasundan\nIPK: 3.75';
  String location = 'Bandung, Jawa Barat';
  String contact = 'ade.rizqy@student.unpas.ac.id';
  String? profileImagePath;

  // List untuk menampung pengalaman
  List<Experience> experiences = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu Utama',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryHome()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final Experience? newExp = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadExperiencePage()),
                );
                if (newExp != null) {
                  setState(() {
                    experiences.add(newExp);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan akan segera hadir.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  // Penyesuaian kIsWeb agar aman di Web (Chrome/Edge) maupun Android
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImagePath != null
                        ? (kIsWeb
                        ? NetworkImage(profileImagePath!)
                        : FileImage(File(profileImagePath!))) as ImageProvider
                        : const NetworkImage('https://github.com/identicons/aderizqy.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Row(
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')),
                Expanded(child: StatBox(label: 'Teman', value: '128')),
                Expanded(child: StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),

            SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: about,
            ),
            SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: education,
            ),
            SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: location,
            ),
            SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: contact,
            ),

            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 28),
                        SizedBox(width: 16),
                        Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: const [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Firebase')),
                        Chip(label: Text('Git')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (experiences.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pengalaman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...experiences.map((exp) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar diset ukurannya jadi kotak 100x100
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: kIsWeb
                          ? Image.network(
                        exp.imagePath,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(exp.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Teks mengisi sisa ruang menggunakan Expanded
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(exp.description, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Map<String, String?>? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(
                currentName: name,
                currentAbout: about,
                currentEducation: education,
                currentLocation: location,
                currentContact: contact,
                currentImagePath: profileImagePath,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              name = result['name'] ?? name;
              about = result['about'] ?? about;
              education = result['education'] ?? education;
              location = result['location'] ?? location;
              contact = result['contact'] ?? contact;
              profileImagePath = result['imagePath'];
            });
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// ==========================================
// HALAMAN EDIT PROFILE
// ==========================================
class EditProfilePage extends StatefulWidget {
  final String currentName, currentAbout, currentEducation, currentLocation, currentContact;
  final String? currentImagePath;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentAbout,
    required this.currentEducation,
    required this.currentLocation,
    required this.currentContact,
    this.currentImagePath,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController aboutCtrl;
  late TextEditingController eduCtrl;
  late TextEditingController locCtrl;
  late TextEditingController contactCtrl;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.currentName);
    aboutCtrl = TextEditingController(text: widget.currentAbout);
    eduCtrl = TextEditingController(text: widget.currentEducation);
    locCtrl = TextEditingController(text: widget.currentLocation);
    contactCtrl = TextEditingController(text: widget.currentContact);
    selectedImagePath = widget.currentImagePath;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImagePath = image.path;
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    aboutCtrl.dispose();
    eduCtrl.dispose();
    locCtrl.dispose();
    contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Informasi Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: selectedImagePath != null
                        ? (kIsWeb
                        ? NetworkImage(selectedImagePath!)
                        : FileImage(File(selectedImagePath!))) as ImageProvider
                        : const NetworkImage('https://github.com/identicons/aderizqy.png'),
                  ),
                  const SizedBox(height: 4),
                  const Text('Foto Profil', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Ganti Foto dari Galeri'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: aboutCtrl, decoration: const InputDecoration(labelText: 'Bio/Tentang', border: OutlineInputBorder()), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: eduCtrl, decoration: const InputDecoration(labelText: 'Pendidikan', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: contactCtrl, decoration: const InputDecoration(labelText: 'Kontak', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {
                Navigator.pop<Map<String, String?>>(context, {
                  'name': nameCtrl.text,
                  'about': aboutCtrl.text,
                  'education': eduCtrl.text,
                  'location': locCtrl.text,
                  'contact': contactCtrl.text,
                  'imagePath': selectedImagePath,
                });
              },
              child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN UPLOAD PENGALAMAN BARU
// ==========================================
class UploadExperiencePage extends StatefulWidget {
  const UploadExperiencePage({super.key});

  @override
  State<UploadExperiencePage> createState() => _UploadExperiencePageState();
}

class _UploadExperiencePageState extends State<UploadExperiencePage> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  String? expImagePath;

  Future<void> _pickExpImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        expImagePath = image.path;
      });
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Pengalaman')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Informasi Pengalaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickExpImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
                child: expImagePath == null
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Ketuk untuk pilih gambar', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(expImagePath!, fit: BoxFit.cover)
                      : Image.file(File(expImagePath!), fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: () {
                if (titleCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty && expImagePath != null) {
                  Navigator.pop(context, Experience(imagePath: expImagePath!, title: titleCtrl.text, description: descCtrl.text));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Semua field & gambar wajib diisi!')));
                }
              },
              child: const Text('Simpan Pengalaman'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HELPER WIDGETS & GALLERY DEMO
// ==========================================
class StatBox extends StatelessWidget {
  final String label, value;
  const StatBox({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title, content;
  const SectionCard({super.key, required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return ListTile(
            leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
            title: Text(name),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(name: name))),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    Widget demo;
    if (name == 'Display') {
      demo = const DisplayDemo();
    } else if (name == 'Input') {
      demo = const InputDemo();
    } else if (name == 'Button') {
      demo = const ButtonDemo();
    } else if (name == 'Feedback') {
      demo = const FeedbackDemo();
    } else {
      demo = const LayoutDemo();
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(padding: const EdgeInsets.all(16), child: demo),
    );
  }
}

class DisplayDemo extends StatelessWidget {
  const DisplayDemo({super.key});
  @override
  Widget build(BuildContext context) => const Column(children: [
    Card(child: ListTile(leading: Icon(Icons.album), title: Text('Contoh Card'))),
    Divider(),
    Wrap(spacing: 8, children: [Chip(label: Text('Tag 1')), Chip(label: Text('Tag 2'))]),
  ]);
}

class InputDemo extends StatelessWidget {
  const InputDemo({super.key});
  @override
  Widget build(BuildContext context) => const Column(children: [
    TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Input Teks')),
    SwitchListTile(title: Text('Opsi Switch'), value: true, onChanged: null),
  ]);
}

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});
  @override
  Widget build(BuildContext context) => Column(children: [
    ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
    OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
  ]);
}

class FeedbackDemo extends StatelessWidget {
  const FeedbackDemo({super.key});
  @override
  Widget build(BuildContext context) => const Column(children: [
    LinearProgressIndicator(),
    SizedBox(height: 20),
    CircularProgressIndicator(),
  ]);
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [Container(width: 50, height: 50, color: Colors.red), Container(width: 50, height: 50, color: Colors.blue)],
  );
}