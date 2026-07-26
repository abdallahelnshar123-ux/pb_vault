import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pb_vault/domain/entities/response/platform_account/platform_account.dart';
import 'package:pb_vault/features/home_screen/widget/password_card_item.dart';
import 'package:pb_vault/features/platform_account/cubit/platform_account_view_model.dart';
import 'package:pb_vault/widgets/search_text_field_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';

class SearchPlatformAccountsScreen extends StatefulWidget {
  const SearchPlatformAccountsScreen({
    super.key,
    required this.allAccountsList,
  });

  final List<PlatformAccount> allAccountsList;

  @override
  State<SearchPlatformAccountsScreen> createState() =>
      _SearchPlatformAccountsScreenState();
}

class _SearchPlatformAccountsScreenState
    extends State<SearchPlatformAccountsScreen> {
  late List<PlatformAccount> filteredAccountsList = widget.allAccountsList;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: _builtAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _builtBody(),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _builtAppBar() {
    return AppBar(
      toolbarHeight: 80,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Text('search_password'.tr()),
      elevation: 0,
    );
  }

  Widget _builtBody() {
    return Column(
      spacing: 30,
      children: [
        SearchTextFieldWidget(
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              filteredAccountsList = context
                  .read<PlatformAccountCubit>()
                  .searchPlatformAccounts(
                    accountsList: widget.allAccountsList,
                    searchTerm: value,
                  );
              setState(() {});
            });
          },
        ),
        Expanded(
          child: widget.allAccountsList.isEmpty
              ? Center(
                  child: Text(
                    'no_accounts_to_search_add_some_accounts'.tr(),
                    style: AppStyles.robotoBold16(
                      context,
                      lColor: AppColors.surfaceDark,
                      dColor: AppColors.backgroundLight,
                    ),
                    textAlign: .center,
                  ),
                )
              : filteredAccountsList.isEmpty
              ? Center(
                  child: Text(
                    'no_accounts_matches_search_term'.tr(),
                    style: AppStyles.robotoBold16(
                      context,
                      lColor: AppColors.surfaceDark,
                      dColor: AppColors.backgroundLight,
                    ),
                    textAlign: .center,
                  ),
                )
              : PasswordCardItem(accountsList: filteredAccountsList),
        ),
      ],
    );
  }
}
