import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../domain/entities/import_result.dart';
import '../themes/text_style.dart';
import '../themes/button_style.dart';
import '../themes/drop_zone_colors.dart';
import '../viewmodels/file_upload_viewmodel.dart';

class FileUploadView extends StatefulWidget {
  const FileUploadView({super.key});

  @override
  State<FileUploadView> createState() => _FileUploadViewState();
}

class _FileUploadViewState extends State<FileUploadView> {
  bool _isDragEntered = false;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el ViewModel para mostrar notificaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FileUploadViewModel>().addListener(_handleViewModelChanges);
    });
  }

  @override
  void dispose() {
    context.read<FileUploadViewModel>().removeListener(_handleViewModelChanges);
    super.dispose();
  }

  void _handleViewModelChanges() {
    final viewModel = context.read<FileUploadViewModel>();
    
    switch (viewModel.state) {
      case FileUploadState.success:
        _showSuccessMessage();
        break;
      case FileUploadState.error:
        _showErrorMessage(viewModel.errorMessage ?? 'Error desconocido');
        break;
      default:
        break;
    }
  }

  Color _getDropZoneColor(FileUploadViewModel viewModel) {
    return DropZoneColors.getColorForState(
      isDragEntered: _isDragEntered,
      hasFileSelected: viewModel.hasFileSelected,
      isUploading: viewModel.isUploading,
      hasError: viewModel.state == FileUploadState.error,
    );
  }

  Color _getDropZoneBorderColor(FileUploadViewModel viewModel) {
    return DropZoneColors.getBorderColorForState(
      hasFileSelected: viewModel.hasFileSelected,
      isUploading: viewModel.isUploading,
      hasError: viewModel.state == FileUploadState.error,
      isSuccess: viewModel.state == FileUploadState.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.45;
    final dropHeight = screenSize.height * 0.45;
    final maxHeight = screenSize.height * 0.30;

    return Scaffold(
      backgroundColor: AppTextStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTextStyles.backgroundColor,
        elevation: 0,
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            "Importar Datos",
            style: AppTextStyles.mainTitle,
          ),
        ),
      ),
      body: Container(
        color: AppTextStyles.backgroundColor,
        child: Center(
          child: Container(
            width: maxWidth,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cargue los archivos CSV (Excel)",
                    style: AppTextStyles.normalText,
                  ),
                  const SizedBox(height: 20),
                  _buildDropZone(maxHeight, dropHeight, screenSize),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 10),
                  _buildImportResult(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropZone(double maxHeight, double dropHeight, Size screenSize) {
    return Consumer<FileUploadViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          height: maxHeight,
          child: DropTarget(
            onDragEntered: (_) => setState(() {
              _isDragEntered = true;
            }),
            onDragExited: (_) => setState(() {
              _isDragEntered = false;
            }),
            onDragDone: (details) => _handleFileDrop(details, viewModel),
            child: AnimatedContainer(
              width: double.infinity,
              height: dropHeight,
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: _getDropZoneColor(viewModel),
                border: Border.all(
                  color: _getDropZoneBorderColor(viewModel),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _buildDropZoneContent(screenSize, viewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropZoneContent(Size screenSize, FileUploadViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          viewModel.isUploading ? Icons.cloud_sync : Icons.drive_folder_upload,
          size: _calculateIconSize(screenSize),
          color: AppTextStyles.darkGray,
        ),
        const SizedBox(height: 8),
        Text(
          viewModel.isUploading 
            ? "Subiendo archivo..." 
            : "Arrastre y suelte el archivo aquí",
          style: AppTextStyles.dropZoneText,
        ),
        const SizedBox(height: 4),
        Text(
          "Archivo: ${viewModel.fileName ?? 'No seleccionado'}",
          style: AppTextStyles.dropZoneInfoText,
        ),
        if (!viewModel.hasFileSelected && !viewModel.isUploading)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Solo archivos CSV (.csv)",
              style: AppTextStyles.smallText,
            ),
          ),
        if (viewModel.isUploading)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTextStyles.primaryBlue),
              strokeWidth: 3,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Consumer<FileUploadViewModel>(
      builder: (context, viewModel, child) {
        return Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              ElevatedButton(
                style: viewModel.canUpload
                    ? AppButtonStyles.confirm
                    : AppButtonStyles.disabled,
                onPressed: viewModel.canUpload
                    ? () => viewModel.importFile()
                    : null,
                child: Text(
                  viewModel.isUploading ? 'Cargando...' : 'Cargar',
                  style: AppTextStyles.buttonText.copyWith(
                    color: viewModel.canUpload ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: viewModel.canCancel
                      ? AppButtonStyles.cancel
                      : AppButtonStyles.disabled,
                  onPressed: viewModel.canCancel
                      ? () => viewModel.clearFile()
                      : null,
                  child: Text(
                    'Cancelar',
                    style: AppTextStyles.buttonText.copyWith(
                      color: viewModel.canCancel ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImportResult() {
    return Consumer<FileUploadViewModel>(
      builder: (context, viewModel, child) {
        final result = viewModel.lastImportResult;
        if (result == null) return const SizedBox.shrink();

        final isSuccess = result.isSuccessful;
        final backgroundColor = isSuccess 
            ? AppTextStyles.successGreen.withAlpha(25)
            : AppTextStyles.errorRed.withAlpha(25);
        final borderColor = isSuccess 
            ? AppTextStyles.successGreen 
            : AppTextStyles.errorRed;
        final titleColor = isSuccess 
            ? AppTextStyles.successGreen.withAlpha(230)
            : AppTextStyles.errorRed.withAlpha(230);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: borderColor.withAlpha(51),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: titleColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Resultado de Importación - ${result.fileType}',
                      style: AppTextStyles.resultTitle.copyWith(
                        color: titleColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildResultStatistics(result),
              if (result.hasErrors) ...[
                const SizedBox(height: 8),
                _buildErrorsList(result),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultStatistics(ImportResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(128),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          _buildStatRow('Total procesados:', '${result.totalProcessed}'),
          _buildStatRow('Exitosos:', '${result.successful}', 
                        color: AppTextStyles.successGreen),
          if (result.failed > 0)
            _buildStatRow('Fallidos:', '${result.failed}', 
                          color: AppTextStyles.errorRed),
          if (result.duplicatesSkipped > 0)
            _buildStatRow('Duplicados omitidos:', '${result.duplicatesSkipped}', 
                          color: AppTextStyles.warningOrange),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.resultText),
          Text(
            value, 
            style: AppTextStyles.resultText.copyWith(
              fontWeight: FontWeight.w600,
              color: color ?? AppTextStyles.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorsList(ImportResult result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTextStyles.errorRed.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppTextStyles.errorRed.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: AppTextStyles.errorRed,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Errores encontrados:',
                style: AppTextStyles.resultText.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTextStyles.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...result.errors.take(3).map((error) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: AppTextStyles.smallText.copyWith(
                  color: AppTextStyles.errorRed,
                )),
                Expanded(
                  child: Text(
                    error, 
                    style: AppTextStyles.smallText.copyWith(
                      color: AppTextStyles.errorRed.withAlpha(204),
                    ),
                  ),
                ),
              ],
            ),
          )),
          if (result.errors.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '... y ${result.errors.length - 3} errores más',
                style: AppTextStyles.smallText.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTextStyles.errorRed.withAlpha(179),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleFileDrop(DropDoneDetails details, FileUploadViewModel viewModel) {
    setState(() {
      _isDragEntered = false;
    });

    if (details.files.isNotEmpty) {
      final xfile = details.files.first;

      if (viewModel.validateFile(xfile)) {
        viewModel.updateFile(xfile);
      } else {
        _showErrorMessage('Por favor, seleccione únicamente archivos .csv');
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Archivo importado correctamente',
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTextStyles.successGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.buttonText.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTextStyles.errorRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16), 
      ),
    );
  }

  double _calculateIconSize(Size screenSize) {
    bool isSmallScreen = screenSize.width < 600 || screenSize.height < 647;
    bool isVerySmallScreen = screenSize.width < 400 || screenSize.height < 493;

    if (isVerySmallScreen) {
      return (screenSize.width * 0.08).clamp(24.0, 32.0);
    } else if (isSmallScreen) {
      return (screenSize.width * 0.10).clamp(32.0, 64.0);
    } else {
      return (screenSize.width * 0.10 + screenSize.height * 0.05).clamp(
        48.0,
        128.0,
      );
    }
  }
}