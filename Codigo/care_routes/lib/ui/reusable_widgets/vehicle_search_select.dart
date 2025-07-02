import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/vehicle_with_driver.dart';
import '../../providers/vehicle_search_providers.dart';

class VehicleSearchSelect extends ConsumerStatefulWidget {
  const VehicleSearchSelect({
    super.key,
    required this.onSelected,
  });

  final void Function(VehicleWithDriver vehicle) onSelected;

  @override
  ConsumerState<VehicleSearchSelect> createState() =>
      _VehicleSearchSelectState();
}

class _VehicleSearchSelectState extends ConsumerState<VehicleSearchSelect> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;
  Timer? _debounce;
  bool _showList = false;
  List<VehicleWithDriver>? _cachedResults;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showList = _focus.hasFocus;
    });
    
    if (_focus.hasFocus) {
      ref.read(vehicleQueryProvider.notifier).state = _ctrl.text.trim();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final trimmedText = text.trim();
      ref.read(vehicleQueryProvider.notifier).state = trimmedText;
      
      if (trimmedText.isNotEmpty && !_showList) {
        setState(() {
          _showList = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(vehicleQueryProvider);
    final resultsAsync = ref.watch(vehicleSearchProvider(query));
    
    // Actualizamos los resultados en caché cuando hay nuevos datos
    resultsAsync.whenData((data) {
      _cachedResults = data;
    });

    final shouldShowList = _showList || query.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _ctrl,
          focusNode: _focus,
          onChanged: _onChanged,
          decoration: const InputDecoration(
            labelText: 'Buscar vehículo o conductor',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        // Contenedor con animación de altura y opacidad
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              ),
            );
          },
          child: shouldShowList
              ? _buildResultsList(resultsAsync)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildResultsList(AsyncValue<List<VehicleWithDriver>> resultsAsync) {
    return resultsAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('Sin coincidencias')),
          );
        }
        
        // Calculamos la altura basada en la cantidad de elementos
        // con un mínimo y un máximo
        final itemHeight = 72.0; // Altura aproximada de un ListTile con subtitle
        final dividerHeight = 1.0;
        final listHeight = (list.length * itemHeight) + 
                          ((list.length - 1) * dividerHeight);
        
        // Limitamos la altura entre 100 y 300 píxeles
        final constrainedHeight = listHeight.clamp(100.0, 300.0);
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: constrainedHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.5),
              itemBuilder: (_, i) {
                final v = list[i];
                return ListTile(
                  title: Text('${v.licensePlate} · ${v.model}'),
                  subtitle: Text('${v.driverName} – ${v.idNumber}'),
                  leading: const Icon(Icons.directions_car),
                  onTap: () {
                    widget.onSelected(v);
                    _ctrl.text = '${v.licensePlate} - ${v.driverName}';
                    setState(() {
                      _showList = false;
                    });
                    _focus.unfocus();
                  },
                );
              },
            ),
          ),
        );
      },
      loading: () {
        // Muestra un indicador de carga, pero mantiene la lista anterior visible
        // mientras carga para evitar parpadeos
        if (_cachedResults != null && _cachedResults!.isNotEmpty) {
          return Stack(
            children: [
              _buildResultsList(AsyncData(_cachedResults!)),
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 100, 
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
      error: (e, _) => Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'Error: $e',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      ),
    );
  }
}