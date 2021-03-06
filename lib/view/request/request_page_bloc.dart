//
// request_page_bloc.dart
// mob_conf_video
//
// Copyright (c) 2018 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:mob_conf_video/RepositoryProvider.dart';
import 'package:mob_conf_video/common/subscription_holder.dart';
import 'package:mob_conf_video/model/event.dart';
import 'package:mob_conf_video/repository/event_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class RequestPageBloc implements Bloc {
  // inputs

  // outputs
  Stream<Iterable<Event>> get allEvents;
}

class DefaultRequestPageBloc implements RequestPageBloc {
  // inputs

  // outputs
  get allEvents => _allEvents;

  final SubscriptionHolder _subscriptions;
  final Observable<Iterable<Event>> _allEvents;

  DefaultRequestPageBloc._(
    this._subscriptions,
    this._allEvents,
  );

  factory DefaultRequestPageBloc({
    @required EventRepository eventRepository,
  }) {
    final subscriptions = SubscriptionHolder();

    final allEvents = Observable(eventRepository.getAllEventsStream())
        .map((iterable) => iterable.toList())
        .publishValue();
    subscriptions.add(allEvents.connect());

    return DefaultRequestPageBloc._(
      subscriptions,
      allEvents,
    );
  }

  void dispose() {
    _subscriptions.dispose();
  }
}

class DefaultRequestPageBlocProvider extends BlocProvider<RequestPageBloc> {
  DefaultRequestPageBlocProvider({
    @required Widget child,
  }) : super(
          child: child,
          creator: (context) {
            final provider = RepositoryProvider.of(context);
            return DefaultRequestPageBloc(
              eventRepository: provider.eventRepository,
            );
          },
        );
}
