// app/modules/address/views/add_address_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/address_controller.dart';
import '../../../data/models/address_model.dart';

class AddAddressView extends StatefulWidget {
  final UserAddress? address;

  const AddAddressView({super.key, this.address});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();
  final AddressController _controller = Get.find<AddressController>();

  final _countyController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _streetController = TextEditingController();
  final _subCountyController = TextEditingController();
  final _wardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    if (widget.address != null) {
      _countyController.text = widget.address!.county;
      _phoneNumberController.text = widget.address!.phoneNumber;
      _postalCodeController.text = widget.address!.postalCode;
      _streetController.text = widget.address!.street;
      _subCountyController.text = widget.address!.subCounty;
      _wardController.text = widget.address!.ward;
    }
  }

  @override
  void dispose() {
    _countyController.dispose();
    _phoneNumberController.dispose();
    _postalCodeController.dispose();
    _streetController.dispose();
    _subCountyController.dispose();
    _wardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Address' : 'Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _streetController,
                label: 'Street Address',
                hint: 'Enter your street address',
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _wardController,
                label: 'Ward',
                hint: 'Enter your ward',
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _subCountyController,
                label: 'Sub-County',
                hint: 'Enter your sub-county',
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _countyController,
                label: 'County',
                hint: 'Enter your county',
                isRequired: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _postalCodeController,
                label: 'Postal Code',
                hint: 'Enter postal code',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                isRequired: true,
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _controller.isCreatingAddress.value ||
                            _controller.isUpdatingAddress.value
                        ? null
                        : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                    ),
                    child:
                        _controller.isCreatingAddress.value ||
                            _controller.isUpdatingAddress.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Address' : 'Save Address',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.address != null) {
        // Update existing address
        _controller.updateAddress(
          addressId: widget.address!.id,
          county: _countyController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          street: _streetController.text.trim(),
          subCounty: _subCountyController.text.trim(),
          ward: _wardController.text.trim(),
        );
      } else {
        // Create new address
        _controller.createAddress(
          county: _countyController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          street: _streetController.text.trim(),
          subCounty: _subCountyController.text.trim(),
          ward: _wardController.text.trim(),
        );
      }
    }
  }
}
