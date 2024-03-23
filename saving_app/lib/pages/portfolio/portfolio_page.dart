import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:saving_app/styles/colors.dart';
import 'package:saving_app/styles/text_style.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25),
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/bg-container-2.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: kGrey,
                  blurRadius: 5,
                  offset: Offset.fromDirection(2),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Text(
                    'My Portfolio',
                    style: kHeading6.copyWith(
                      color: kWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Savings Value',
                    style: kSubtitle2.copyWith(
                      color: kWhite,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Rp 12.480.000',
                    style: kHeading5.copyWith(
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _portfolioCardList(
            'assets/icons/pension.png',
            'Pension savings funds',
            0.3,
            'Rp. 10.430.000 / Rp. 40.000.000',
            'Last saving February 19',
          ),
          _portfolioCardList(
            'assets/icons/camera.png',
            'Camera',
            0.5,
            'Rp. 2.050.000 / Rp. 4.000.000',
            'Last saving February 16',
          ),
          _portfolioCardList(
            'assets/icons/camera.png',
            'Camera',
            0.5,
            'Rp. 2.050.000 / Rp. 4.000.000',
            'Last saving February 16',
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 13,
                    color: kLuckyBlue,
                  ),
                  Text(
                    'add portfolio',
                    style: kButton2.copyWith(
                      color: kLuckyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: kWhite,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                elevation: 4,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _portfolioCardList(
    String icon,
    String title,
    double percent,
    String amount,
    String time,
  ) {
    return Container(
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        top: 20,
      ),
      padding: EdgeInsets.fromLTRB(15, 19, 15, 14),
      constraints: BoxConstraints.expand(
        height: 130,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: kGrey,
            blurRadius: 1,
            offset: Offset.fromDirection(1, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            child: CircleAvatar(
              backgroundColor: kTropicalBlue,
              child: Image.asset(
                icon,
                width: 24,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kSubtitle1,
                ),
                SizedBox(
                  height: 12,
                ),
                LinearPercentIndicator(
                  lineHeight: 4,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  percent: percent,
                  progressColor: kBlueRibbon,
                  backgroundColor: kGrey.withOpacity(0.3),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  amount,
                  style: kBody2.copyWith(
                    color: kGrey,
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: kCaption.copyWith(
                      color: kLightGray,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
