// Typealiases.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

typealias ViewDataHandler<T> = (ViewData<T>) -> ()
typealias ResultHandler<T> = (Result<T?, Error>) -> ()
typealias ImageHandler = (UIImage?) -> ()
typealias VoidHandler = () -> ()
