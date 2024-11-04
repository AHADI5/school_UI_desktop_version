import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:school_desktop/features/discipline/model/discipline.dart';
import 'package:school_desktop/features/discipline/model/rules_request.dart';
import 'package:school_desktop/features/discipline/service/discipline_service.dart';
import 'package:school_desktop/utils/constants.dart';

class DisciplinePage extends StatefulWidget {
  const DisciplinePage({Key? key}) : super(key: key);

  @override
  _DisciplinePageState createState() => _DisciplinePageState();
}

class _DisciplinePageState extends State<DisciplinePage>
    with SingleTickerProviderStateMixin {
  final RuleRequestService _ruleRequestService = RuleRequestService();
  final Logger _logger = Logger();
  List<Rule> _rules = [];
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRules();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchRules() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRules = await _ruleRequestService
          .fetchRules('$disciplineUrl/2/getRulesBySchoolID');
      setState(() {
        _rules = fetchedRules ?? [];
      });
    } catch (error) {
      _logger.e("Failed to fetch rules", error: error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openAddRuleDialog() async {
    await showDialog(
      context: context,
      builder: (context) => _AddRuleDialog(onSave: _fetchRules),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Discipline'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Règlements scolaire'),
            Tab(text: 'Dossiers disciplinaire'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRulesManagementTab(),
          _buildDisciplinaryRecordsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddRuleDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Add Rule',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRulesManagementTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _rules.length,
            itemBuilder: (context, index) {
              final rule = _rules[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(utf8.decode(rule.title.runes.toList())),
                  subtitle: Text(utf8.decode(rule.content.runes.toList())),
                ),
              );
            },
          );
  }

  Widget _buildDisciplinaryRecordsTab() {
    return const Center(
      child: Text(
        'Dossiers disciplinaire en construction',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class _AddRuleDialog extends StatefulWidget {
  final VoidCallback onSave;

  const _AddRuleDialog({required this.onSave});

  @override
  __AddRuleDialogState createState() => __AddRuleDialogState();
}

class __AddRuleDialogState extends State<_AddRuleDialog> {
  final List<RuleRequest> _ruleRequests = [];
  final _formKey = GlobalKey<FormState>();
  final RuleRequestService _ruleRequestService = RuleRequestService();
  bool _isSaving = false;

  void _addNewRule() {
    setState(() {
      _ruleRequests.add(RuleRequest(
        title: '',
        schoolID: 2,
        content: '',
        violation: [],
      ));
    });
  }

  void _removeRule(int ruleIndex) {
    setState(() {
      _ruleRequests.removeAt(ruleIndex);
    });
  }

  void _addViolationType(int ruleIndex) {
    setState(() {
      _ruleRequests[ruleIndex].violation.add(Violation(
        description: '',
        occurrenceNumber: 1,
        sanctionPredefinedType: '',
        sanctionType: '',
        title: '',
      ));
    });
  }

  void _removeViolationType(int ruleIndex, int violationIndex) {
    setState(() {
      _ruleRequests[ruleIndex].violation.removeAt(violationIndex);
    });
  }

  Future<void> _saveRules() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });
      try {
        await _ruleRequestService.createRules('$disciplineUrl/newRules', _ruleRequests);
        widget.onSave();
        Navigator.pop(context);
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ajouter des règlements',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  itemCount: _ruleRequests.length,
                  itemBuilder: (context, ruleIndex) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Règlement',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removeRule(ruleIndex),
                                  tooltip: 'Supprimer le règlement',
                                ),
                              ],
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Titre du règlement'),
                              onChanged: (value) => _ruleRequests[ruleIndex].title = value,
                              validator: (value) =>
                                  value!.isEmpty ? 'Veuillez entrer un titre' : null,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Contenu du règlement'),
                              onChanged: (value) => _ruleRequests[ruleIndex].content = value,
                              validator: (value) =>
                                  value!.isEmpty ? 'Veuillez entrer le contenu' : null,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Types de violation',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                                  onPressed: () => _addViolationType(ruleIndex),
                                  tooltip: 'Ajouter un type de violation',
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _ruleRequests[ruleIndex].violation.length,
                              itemBuilder: (context, violationIndex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Violation'),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _removeViolationType(
                                                    ruleIndex, violationIndex),
                                                tooltip: 'Supprimer la violation',
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(labelText: 'Description'),
                                            onChanged: (value) => _ruleRequests[ruleIndex]
                                                .violation[violationIndex]
                                                .description = value,
                                            validator: (value) =>
                                                value!.isEmpty ? 'Entrez une description' : null,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                                labelText: 'Type de sanction pré-défini'),
                                            onChanged: (value) => _ruleRequests[ruleIndex]
                                                .violation[violationIndex]
                                                .sanctionPredefinedType = value,
                                          ),
                                          TextFormField(
                                            decoration: const InputDecoration(labelText: 'Type de sanction'),
                                            onChanged: (value) => _ruleRequests[ruleIndex]
                                                .violation[violationIndex]
                                                .sanctionType = value,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un règlement'),
                  onPressed: _addNewRule,
                ),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveRules,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}