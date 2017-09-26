// $Id$
/** \file expression.h Implements an example calculator class group. */

#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <map>
#include <vector>
#include <ostream>
#include <stdexcept>
#include <cmath>


class StateAssignmentNode
{
public:
	StateAssignmentNode() {};
	~StateAssignmentNode() {};
	std::string getName() { return m_Name; }
	void setName(const std::string& name) { m_Name = name; }
	std::string getValue() { return m_Value; }
	void setValue(const std::string& value) { m_Value = value; }
private:
	std::string m_Name;
	std::string m_Value;
};




class PassNode
{
public:
	PassNode() {}
	~PassNode() {}
	std::string getName() { return m_Name; }
	void setName(const std::string& name) { m_Name = name; }

	std::vector<StateAssignmentNode> getStateAssignments() { return mStateAssignments; }
	void AddStateAssignment(const StateAssignmentNode& state) { mStateAssignments.push_back(state); }

private:
	std::string m_Name;
	std::vector<StateAssignmentNode> mStateAssignments;
};



class TechniqueNode
{

public:
	TechniqueNode():
		m_Name(nullptr)
	{}
	~TechniqueNode() {}

	const std::string* getName() const { return m_Name; }
	void setName(std::string& name)
	{
		if (m_Name != nullptr) delete m_Name;
		m_Name = &name;
	}
	std::vector<PassNode*> getPasses() const { return m_PassNodes; }
	void AddPass(PassNode& pass) { m_PassNodes.push_back(&pass); }
private:
	std::string* m_Name;
	std::vector<PassNode*> m_PassNodes;
};



class DxEffectsTree
{
public:
	DxEffectsTree() {}
	~DxEffectsTree()
	{
		for (auto tec:m_Techniques)
		{
			delete tec;
		}
		m_Techniques.clear();
	}
	const std::vector<TechniqueNode*> getTechiques() const { return m_Techniques; }
	void AddTechnique(TechniqueNode& technique) { m_Techniques.push_back(&technique); }
private:
	std::vector<TechniqueNode*> m_Techniques;
};


#endif // EXPRESSION_H
