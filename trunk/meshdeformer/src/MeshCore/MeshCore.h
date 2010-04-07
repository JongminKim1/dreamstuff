#ifndef MESHCORE_H
#define MESHCORE_H

#include <CGAL/basic.h>
#include <CGAL/Cartesian.h>
//#include <CGAL/Simple_cartesian.h>
#include <CGAL/Polyhedron_3.h>
#include <CGAL/IO/Polyhedron_iostream.h>
#include <CGAL/Polyhedron_incremental_builder_3.h>
#include <CGAL/Polyhedron_items_with_id_3.h>

#include <CGAL/iterator.h>

#define KernelType float

//typedef CGAL::Simple_cartesian<KernelType> Kernel;
typedef CGAL::Cartesian<KernelType> Kernel;
typedef Kernel::FT FT;
typedef Kernel::Vector_3 Vector_3;
typedef Kernel::Point_3 Point_3;
typedef Kernel::Iso_cuboid_3 Iso_cuboid_3;

typedef CGAL::Polyhedron_3<Kernel,
  CGAL::Polyhedron_items_with_id_3> Polyhedron;


typedef Polyhedron::Vertex Vertex;
typedef Polyhedron::Vertex_iterator Vertex_iterator;
typedef Polyhedron::Vertex_handle Vertex_handle;
typedef Polyhedron::Halfedge_iterator Halfedge_iterator;
typedef Polyhedron::Halfedge_handle Halfedge_handle;
typedef Polyhedron::Edge_iterator Edge_iterator;
typedef Polyhedron::Point_iterator Point_iterator;

typedef Polyhedron::Facet_handle Facet_handle;
typedef Polyhedron::Facet_iterator Facet_iterator;
typedef Polyhedron::Halfedge_around_vertex_const_circulator Halfedge_around_vertex_const_circulator;
typedef Polyhedron::Halfedge_around_vertex_circulator Halfedge_around_vertex_circulator;
typedef Polyhedron::Halfedge_around_facet_circulator Halfedge_around_facet_circulator;


/**
@brief: MeshCore is the core object representing the mesh
*/
class MeshCore : public Polyhedron
{
 public:
  MeshCore();
  ~MeshCore();
 private:
  void set_vertex_indices();
  void set_facet_indices();
  void set_halfedge_indices();
 public:
  void set_indices();
  void compute_normals_per_facet();
  void compute_normals_per_vertex();
  unsigned int degree(Facet_handle pFacet);
  unsigned int valence(Vertex_handle pVertex);
  
  void render();
 public:
  Iso_cuboid_3& get_bounding_box(){ return bounding_box_;}
  const Iso_cuboid_3 get_bounding_box() const { return bounding_box_; }
  void compute_bounding_box();
 private:
  Iso_cuboid_3 bounding_box_;

  //Test methods
public:
  void test_print_vertex_handles();
  void test_print_halfedge_handles();
  void test_print_facet_handles();
      
private:
  //Initialize in MeshBuilder
  typedef CGAL::Random_access_adaptor<Vertex_iterator> Random_access_index;
  Random_access_index index_to_vertex_map;  //store the id to Vertex_handle mapping
public:
  Vertex_handle get_vertex_handle(int idx);
  void init_index_to_vertex_map();
};
  
  
  
#endif
