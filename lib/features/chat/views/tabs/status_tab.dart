import 'package:flutter/material.dart';
import 'package:mysocial_app/features/chat/widgets/json.dart';
import 'package:sliver_tools/sliver_tools.dart';

class StatusTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        MultiSliver(children: [
          SliverToBoxAdapter(
            child: Column(children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(profile[0]['img']),
                                          fit: BoxFit.cover)),
                                ),
                                Positioned(
                                  right: 5,
                                  bottom: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle, color: primary),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "My Status",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Add to my status",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.5)),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: white.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: primary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: white.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Center(
                  child: Text(
                    "No recent updates to show right now.",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ]),
          ),
          //stories list here
        ]),
      ],
    );
  }
}