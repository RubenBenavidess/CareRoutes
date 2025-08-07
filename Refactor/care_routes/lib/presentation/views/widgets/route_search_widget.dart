// widgets/route_search_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/use_cases/search_route_usecase.dart';
import '../../viewmodels/route_management_viewmodel.dart';
class RouteSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(RouteWithStops) onRouteSelected;

  const RouteSearchWidget({
    super.key,
    required this.controller,
    required this.onRouteSelected,
  });

  @override
  State<RouteSearchWidget> createState() => _RouteSearchWidgetState();
}

class _RouteSearchWidgetState extends State<RouteSearchWidget> {
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: 'Buscar rutas existentes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {
                          _showResults = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                context.read<RouteManagementViewModel>().searchRoutes(query: value);
                setState(() {
                  _showResults = true;
                });
              } else {
                setState(() {
                  _showResults = false;
                });
              }
            },
          ),
          
          if (_showResults)
            Consumer<RouteManagementViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isSearching) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (viewModel.searchResults.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No se encontraron rutas'),
                  );
                }
                
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      final route = viewModel.searchResults[index];
                      return ListTile(
                        title: Text(route.route.name),
                        subtitle: Text('${route.stops.length} paradas'),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          widget.onRouteSelected(route);
                          setState(() {
                            _showResults = false;
                          });
                          widget.controller.text = route.route.name;
                        },
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}