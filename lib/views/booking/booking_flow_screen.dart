import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/service.dart';
import '../../providers/service_provider.dart';
import '../../providers/booking_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/nihara_app_bar.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _currentStep = 0;

  BeautyService? _selectedService;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '11:00 AM';
  String _locationType = 'At Salon'; // 'At Salon' or 'At Home Service'
  final TextEditingController _addressController = TextEditingController(
    text: 'Flat 302, Royal Palms, Jubilee Hills, Hyderabad',
  );
  Artist? _selectedArtist;

  final List<String> _timeSlots = [
    '09:30 AM',
    '11:00 AM',
    '01:00 PM',
    '02:30 PM',
    '04:00 PM',
    '05:30 PM',
    '07:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingDraftProvider);
    if (draft.service != null) {
      _selectedService = draft.service;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a service first')),
      );
      return;
    }
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    } else {
      _confirmBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _confirmBooking() {
    final draft = BookingDraft(
      service: _selectedService,
      date: _selectedDate,
      timeSlot: _selectedTimeSlot,
      locationType: _locationType,
      address: _locationType == 'At Home Service' ? _addressController.text : 'Nihara Flagship Salon, Bandra, Mumbai',
      selectedArtist: _selectedArtist,
    );

    final booking = ref.read(bookingsProvider.notifier).createBooking(draft);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.roseLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Appointment Confirmed!',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Booking Ref: ${booking.bookingId}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your service for "${booking.service.title}" is scheduled for ${DateFormat('EEE, MMM d, yyyy').format(booking.date)} at ${booking.timeSlot}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View My Bookings',
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                context.push('/my-bookings');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NiharaAppBar(
        title: 'Book Service',
        showBackButton: _currentStep > 0,
      ),
      body: Column(
        children: [
          // Step Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.white,
            child: Row(
              children: List.generate(5, (index) {
                final isActive = index <= _currentStep;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.secondary : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Header Title for Step
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStepTitle(_currentStep),
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Step ${_currentStep + 1} of 5',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildStepContent(services),
            ),
          ),

          // Navigation Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  Expanded(
                    child: CustomButton(
                      text: 'Back',
                      isOutlined: true,
                      onPressed: _previousStep,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: CustomButton(
                    text: _currentStep == 4 ? 'Confirm & Book' : 'Continue',
                    onPressed: _nextStep,
                    icon: _currentStep == 4 ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Select Beauty Service';
      case 1:
        return 'Choose Date & Time';
      case 2:
        return 'Select Location';
      case 3:
        return 'Choose Master Artist';
      case 4:
      default:
        return 'Booking Summary';
    }
  }

  Widget _buildStepContent(List<BeautyService> services) {
    switch (_currentStep) {
      case 0:
        return Column(
          children: services.map((s) {
            final isSelected = _selectedService?.id == s.id;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedService = s;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.roseLight : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : AppColors.border,
                    width: isSelected ? 1.5 : 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(s.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${s.duration} • ₹${s.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isSelected ? AppColors.secondary : AppColors.border,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
                onDateChanged: (d) {
                  setState(() {
                    _selectedDate = d;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select Time Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppColors.secondary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTimeSlot = slot;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 2:
        return Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => _locationType = 'At Salon'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _locationType == 'At Salon' ? AppColors.roseLight : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _locationType == 'At Salon' ? AppColors.secondary : AppColors.border,
                    width: _locationType == 'At Salon' ? 1.5 : 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.storefront_rounded, color: AppColors.secondary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nihara Luxury Salon Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Bandra Flagship Salon, Mumbai', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(
                      _locationType == 'At Salon' ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _locationType = 'At Home Service'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _locationType == 'At Home Service' ? AppColors.roseLight : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _locationType == 'At Home Service' ? AppColors.secondary : AppColors.border,
                    width: _locationType == 'At Home Service' ? 1.5 : 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.home_outlined, color: AppColors.secondary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('At Home Luxury Service (+₹500)', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Therapist visits your home with full equipment', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(
                      _locationType == 'At Home Service' ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
            if (_locationType == 'At Home Service') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Your Delivery & Service Address',
                  hintText: 'Enter full street address, landmark, city, pincode',
                ),
              ),
            ],
          ],
        );

      case 3:
        final artists = _selectedService?.availableArtists ?? mockArtists;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select preferred artist or choose "Any Available Specialist"',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => setState(() => _selectedArtist = null),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _selectedArtist == null ? AppColors.roseLight : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedArtist == null ? AppColors.secondary : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.secondary,
                      child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Any Senior Specialist', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('We will assign the best available master stylist', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(
                      _selectedArtist == null ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
            ...artists.map((artist) {
              final isSelected = _selectedArtist?.id == artist.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedArtist = artist),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.roseLight : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(artist.imageUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(artist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(artist.role, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 14),
                                const SizedBox(width: 2),
                                Text('${artist.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case 4:
      default:
        final servicePrice = _selectedService?.price ?? 0.0;
        final extraCharge = _locationType == 'At Home Service' ? 500.0 : 0.0;
        final total = servicePrice + extraCharge;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(_selectedService!.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_selectedService!.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('Duration: ${_selectedService!.duration}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow('Date', DateFormat('EEE, MMM d, yyyy').format(_selectedDate)),
                  _buildSummaryRow('Time Slot', _selectedTimeSlot),
                  _buildSummaryRow('Location', _locationType),
                  if (_locationType == 'At Home Service')
                    _buildSummaryRow('Address', _addressController.text),
                  _buildSummaryRow('Artist', _selectedArtist?.name ?? 'Any Senior Specialist'),
                  const Divider(height: 24),
                  _buildSummaryRow('Service Charge', '₹${servicePrice.toStringAsFixed(0)}'),
                  if (extraCharge > 0)
                    _buildSummaryRow('At-Home Travel Charge', '₹${extraCharge.toStringAsFixed(0)}'),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Payable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
