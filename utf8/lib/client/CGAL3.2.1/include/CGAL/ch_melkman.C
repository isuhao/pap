
// Copyright (c) 1999  Max-Planck-Institute Saarbruecken (Germany).
// All rights reserved.
//
// This file is part of CGAL (www.cgal.org); you may redistribute it under
// the terms of the Q Public License version 1.0.
// See the file LICENSE.QPL distributed with CGAL.
//
// Licensees holding a valid commercial license may use this file in
// accordance with the commercial license agreement provided with the software.
//
// This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
// WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// $URL: svn+ssh://scm.gforge.inria.fr/svn/cgal/branches/CGAL-3.2-branch/Convex_hull_2/include/CGAL/ch_melkman.C $
// $Id: ch_melkman.C 30657 2006-04-19 13:29:42Z cdelage $
// 
//
// Author(s)     : Stefan Schirra
 

#ifndef CGAL_CH_MELKMAN_C
#define CGAL_CH_MELKMAN_C

#ifndef CGAL_CH_MELKMAN_H
#include <CGAL/ch_melkman.h>
#endif

#ifndef CGAL_CH_NO_POSTCONDITIONS
#include <CGAL/convexity_check_2.h>
#endif // CGAL_CH_NO_POSTCONDITIONS

#include <CGAL/ch_assertions.h>
#include <queue>
#include <iterator>

CGAL_BEGIN_NAMESPACE

template <class InputIterator, class OutputIterator, class Traits>
OutputIterator
ch_melkman( InputIterator first, InputIterator last,
            OutputIterator result, const Traits& ch_traits)
{
  typedef typename Traits::Point_2      Point;
  typedef typename Traits::Segment_2    Segment;
  typedef typename Traits::Equal_2      Equal_2;   
  
  typename Traits::Left_turn_2 left_turn  = ch_traits.left_turn_2_object();
  Equal_2  equal_points = ch_traits.equal_2_object();
  
  CGAL_ch_assertion_code( \
  typename Traits::Less_xy_2 less       = ch_traits.less_xy_2_object(); )
  
  std::deque< Point> Q;
  
  CGAL_ch_expensive_postcondition_code( std::deque< Point> IN; )
  if (first == last) return result;           // 0 elements
  Point p = *first;
  CGAL_ch_expensive_postcondition_code( IN.push_back(p); )
  if (++first == last)
  { *result = p; ++result; return result; }   // 1 element
  Point q = *first;
  CGAL_ch_expensive_postcondition_code( IN.push_back(q); )
  if (++first == last)                        // 2 elements
  {
    *result = p; ++result;
    if (! equal_points(p,q))
    { *result = q; ++result; }
    return result;
  }
  Q.push_back( p);
  
  Point r;
  while (first != last)
  {
    r = *first;
    CGAL_ch_expensive_postcondition_code( IN.push_back(r); )
    // visited input sequence =  p,..., q, r
    if ( left_turn(p,q,r)) { Q.push_back( q);  break; }
    if ( left_turn(q,p,r)) { Q.push_front( q); break; }
    CGAL_ch_assertion( less( p, q) ? less (p, r) : less( r, p));
    q = r;
    ++first;
  }
  
  
  Point current = q;
  if (first != last)           // non-collinear point r exists
  {
    
    current = r;
    // current, Q.front(), ..., Q.back()
    // ccw convex hull of visited points
    Point s;
    while ( ++first != last)
    {
      r = *first;
      CGAL_ch_expensive_postcondition_code( IN.push_back(r); )
      if (left_turn( current, r, Q.front()) || 
          left_turn( Q.back(), r, current))
      // r outside cone Q.front(), current, Q.back() <=>
      // right_turn( current, Q.front(), r) || 
      // right_turn( Q.back(), current, r)
      {
        s = current;
        while (!Q.empty() && !left_turn( r, s, Q.front()))
        //      !left_turn( r, s, Q.front())
        { s = Q.front(); Q.pop_front(); }
        Q.push_front(s);
        s = current;
        while (!Q.empty() &&  !left_turn( s, r, Q.back()))
        //     !right_turn( r, s, Q.back())
        { s = Q.back(); Q.pop_back(); }
        Q.push_back(s);
        current = r;
      }
      
    }
    
  }
  
  
  Q.push_back( current);       // add last point to Q
  CGAL_ch_postcondition( \
  is_ccw_strongly_convex_2( Q.begin(), Q.end(), ch_traits));
  CGAL_ch_expensive_postcondition( \
  ch_brute_force_check_2( IN.begin(),IN.end(), Q.begin(),Q.end(), ch_traits));
  std::copy( Q.begin(), Q.end(), result);
  return result;
  
}

CGAL_END_NAMESPACE


#endif // CGAL_CH_MELKMAN_C
