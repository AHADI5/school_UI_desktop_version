import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:school_desktop/features/discipline/model/discipline.dart';
import 'package:school_desktop/features/discipline/model/rules_request.dart';
import 'package:school_desktop/features/discipline/service/discipline_service.dart';
import 'package:school_desktop/utils/constants.dart';

class RuleManagementPage extends StatefulWidget {
  @override
  _RuleManagementPageState createState() => _RuleManagementPageState();
}

class _RuleManagementPageState extends State<RuleManagementPage> {
  final RuleRequestService _ruleRequestService = RuleRequestService();
  final Logger _logger = Logger();
  List<Rule> _rules = [];

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  Future<void> _fetchRules() async {
    try {
      final fetchedRules = await _ruleRequestService.fetchRules('$disciplineUrl/2/getRulesBySchoolID');
      setState(() {
        _rules = fetchedRules ?? [];
      });
    } catch (error) {
      _logger.e("Failed to fetch rules", error: error);
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
        title: Text('Manage Rules'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _rules.length,
        itemBuilder: (context, index) {
          final rule = _rules[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(rule.title ?? 'No Title'),
              subtitle: Text(rule.content ?? 'No Content'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddRuleDialog,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        tooltip: 'Add Rule',
      ),
    );
  }
}

class _AddRuleDialog extends StatefulWidget {
  final VoidCallback onSave;

  _AddRuleDialog({required this.onSave});

  @override
  __AddRuleDialogState createState() => __AddRuleDialogState();
}

class __AddRuleDialogState extends State<_AddRuleDialog> {
  final List<RuleRequest> _ruleRequests = [];
  final _formKey = GlobalKey<FormState>();
  final RuleRequestService _ruleRequestService = RuleRequestService();

  void _addNewRule() {
    setState(() {
      _ruleRequests.add(RuleRequest(
        title: '',
        schoolID: 0,
        content: '',
        violation: [],
      ));
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

  Future<void> _saveRules() async {
    if (_formKey.currentState!.validate()) {
      for (var rule in _ruleRequests) {
        await _ruleRequestService.createRule('$disciplineUrl/newRules', rule);
      }
      widget.onSave();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Rules',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ruleRequests.length,
                  itemBuilder: (context, ruleIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Rule Title'),
                          onChanged: (value) => _ruleRequests[ruleIndex].title = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a title' : null,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Content'),
                          onChanged: (value) => _ruleRequests[ruleIndex].content = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter content' : null,
                        ),
                        const SizedBox(height: 8),
                        const Text('Violation Types', style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _ruleRequests[ruleIndex].violation.length,
                          itemBuilder: (context, violationIndex) {
                            return Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Description'),
                                  onChanged: (value) => _ruleRequests[ruleIndex]
                                      .violation[violationIndex]
                                      .description = value,
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter a description' : null,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Sanction Predefined Type'),
                                  onChanged: (value) => _ruleRequests[ruleIndex]
                                      .violation[violationIndex]
                                      .sanctionPredefinedType = value,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(labelText: 'Sanction Type'),
                                  onChanged: (value) => _ruleRequests[ruleIndex]
                                      .violation[violationIndex]
                                      .sanctionType = value,
                                ),
                              ],
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => _addViolationType(ruleIndex),
                          child: const Text('Add Violation Type'),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addNewRule,
                    child: const Text('Add Another Rule'),
                  ),
                  ElevatedButton(
                    onPressed: _saveRules,
                    child: const Text('Save Rules'),
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
