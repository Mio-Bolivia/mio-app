import 'package:flutter/material.dart';
import '../thumb_components/thumb_components.dart';

class SellerStoreHeader extends StatefulWidget {
  final String storeName;
  final String storeAvatar;
  final double stars;
  final int reviews;
  final VoidCallback onBackPressed;
  final ValueChanged<String> onSearchChanged;

  const SellerStoreHeader({
    super.key,
    required this.storeName,
    required this.storeAvatar,
    required this.stars,
    required this.reviews,
    required this.onBackPressed,
    required this.onSearchChanged,
  });

  @override
  State<SellerStoreHeader> createState() => _SellerStoreHeaderState();
}

class _SellerStoreHeaderState extends State<SellerStoreHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBackPressed,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.storeAvatar),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.stars}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' (${widget.reviews} reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MioTextField(
            controller: _searchController,
            hintText: 'Buscar productos…',
            prefixIcon: Icons.search_rounded,
            onChanged: widget.onSearchChanged,
          ),
        ],
      ),
    );
  }
}
