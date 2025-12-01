import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _multiOutletEnabled = false;
  bool _multiUserEnabled = true;
  bool _offlineMode = false;
  String _selectedOutlet = 'Outlet 1';
  String _selectedRole = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Umum',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Mode Multi-Outlet'),
                      subtitle: const Text('Mengelola beberapa outlet'),
                      value: _multiOutletEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _multiOutletEnabled = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Mode Multi-User'),
                      subtitle: const Text('Mengelola beberapa pengguna'),
                      value: _multiUserEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _multiUserEnabled = value;
                        });
                      },
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Mode Offline'),
                      subtitle: const Text('Bekerja tanpa koneksi internet'),
                      value: _offlineMode,
                      onChanged: (bool value) {
                        setState(() {
                          _offlineMode = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Outlet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Outlet Saat Ini'),
                      subtitle: Text(_selectedOutlet),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showOutletSelector();
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Tambah Outlet Baru'),
                      onTap: () {
                        _showAddOutletDialog();
                      },
                      trailing: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Pengguna',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Role Saat Ini'),
                      subtitle: Text(_selectedRole),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showRoleSelector();
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Kelola Pengguna'),
                      onTap: () {
                        // Navigate to user management
                      },
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Database',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Backup Database'),
                      subtitle: const Text('Simpan salinan database'),
                      onTap: () {
                        _backupDatabase();
                      },
                      trailing: const Icon(Icons.backup),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Restore Database'),
                      subtitle: const Text('Pulihkan dari backup'),
                      onTap: () {
                        _restoreDatabase();
                      },
                      trailing: const Icon(Icons.restore),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOutletSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Outlet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...['Outlet 1', 'Outlet 2', 'Outlet 3'].map((outlet) {
                return RadioListTile<String>(
                  title: Text(outlet),
                  value: outlet,
                  groupValue: _selectedOutlet,
                  onChanged: (value) {
                    setState(() {
                      _selectedOutlet = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showAddOutletDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Outlet Baru'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Outlet',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add outlet logic
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showRoleSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Role',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...['Admin', 'Kasir', 'Manager'].map((role) {
                return RadioListTile<String>(
                  title: Text(role),
                  value: role,
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _backupDatabase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup database berhasil dibuat'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _restoreDatabase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Database berhasil dipulihkan'),
        backgroundColor: Colors.green,
      ),
    );
  }
}