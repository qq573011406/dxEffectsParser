// $Id$
/** \file expression.h Implements an example calculator class group. */

#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <map>
#include <vector>
#include <ostream>
#include <stdexcept>
#include <cmath>



enum class StateValueType
{
	COMPILE,
	BOOLEAN,
	STRING,
	UNKNOWN,
};

class StateAssignmentValue
{
public:

	StateAssignmentValue(StateValueType vt):
		m_ValueType(StateValueType::UNKNOWN)
	{

	}
	virtual ~StateAssignmentValue()
	{
	}

	const StateValueType getValueType() const { return m_ValueType; }

private:
	StateValueType m_ValueType;
};


class StateCompileValue : StateAssignmentValue
{
public:
	StateCompileValue(StateValueType vt, std::string target, std::string entrypoint) :StateAssignmentValue(vt)
	{
		m_Target = target;
		m_Entrypoint = entrypoint;
	}
	~StateCompileValue()override = default;

	const std::string getTarget() const { return m_Target; }
	const std::string getEntryPoint() const { return m_Entrypoint; }

private:
	std::string m_Target;
	std::string m_Entrypoint;
};


class StateBooleanValue : StateAssignmentValue
{
public:
	StateBooleanValue(StateValueType vt, bool value) :StateAssignmentValue(vt)
	{
		m_Val = value;
	}
	~StateBooleanValue()override = default;

	const bool getValue() const { return m_Val; }

private:
	bool m_Val;
};


class StateStringValue : StateAssignmentValue
{
public:
	StateStringValue(StateValueType vt, std::string value) :StateStringValue(vt)
	{
		m_Val = value;
	}
	~StateStringValue()override = default;

	const std::string getValue() const { return m_Val; }

private:
	std::string m_Val;
};




class StateAssignmentNode
{
public:
	StateAssignmentNode(std::string name, StateAssignmentValue* value,int nameIndex = -1)
	{
		m_Name = name;
		m_Value = value;
		m_NameIndex = nameIndex;
	}
	~StateAssignmentNode() {
		if (m_Value != nullptr) {
			delete m_Value;
			m_Value = nullptr;
		}
	};
	const std::string getName() const { return m_Name; }
	const StateAssignmentValue* getValue() const { return m_Value; }
	const int getNameIndex() const { return m_NameIndex; }
private:
	std::string m_Name;
	int m_NameIndex;
	StateAssignmentValue* m_Value;
};




class PassNode
{
public:
	PassNode(std::string name, std::vector<StateAssignmentNode*> states)
	{
		m_Name = name;
		m_StateAssignments = states;
	}
	~PassNode()
	{
		for (auto state : m_StateAssignments) {
			delete state;
		}
		m_StateAssignments.clear();
	}
	const std::string getName() const { return m_Name; }


	const std::vector<StateAssignmentNode*> getStateAssignments()const { return m_StateAssignments; }

private:
	std::string m_Name;
	std::vector<StateAssignmentNode*> m_StateAssignments;
};



class TechniqueNode
{

public:
	TechniqueNode(){}
	~TechniqueNode()
	{
		for (auto passNode : m_PassNodes) {
			delete passNode;
		}
		m_PassNodes.clear();
	}

	const std::string getName() const { return m_Name; }
	void setName(std::string name)
	{
		m_Name = name;
	}
	std::vector<PassNode*> getPasses() const { return m_PassNodes; }
	void AddPass(PassNode& pass) { m_PassNodes.push_back(&pass); }
private:
	std::string m_Name;
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
